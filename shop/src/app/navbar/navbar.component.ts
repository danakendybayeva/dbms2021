import { Component, OnInit } from '@angular/core';
import { Genre } from '../genre';
import { GenresService } from '../genres.service';
import { Product} from '../products';
import { ProductService } from '../product.service';


@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent implements OnInit {
  genres: Genre[] = [];
  books: Product[] = [];
  searchBox = {
    text: ''
  };

  constructor(
    private genresService: GenresService,
    private productService: ProductService
  ) { }

  ngOnInit(): void {
    this.getGenres();
    this.show();
  }

  getGenres(): void {
    this.genresService.getGenres().subscribe( genres => this.genres = genres);
  }

  select(): void {
    const term = (document.getElementById('searchValue') as HTMLInputElement).value;
    this.searchBox.text = term;
    console.log(term);
  }

  show(): void{
    const term = (document.getElementById('searchValue') as HTMLInputElement).value;
    this.productService.searchBook(term)
      .subscribe(books => this.books = books);
  }

}
