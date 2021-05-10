import { Component, OnInit } from '@angular/core';
import { Product } from '../products';
import { CartService } from '../cart.service';
import { ProductService } from '../product.service';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { Genre } from '../genre';
import { GenresService} from '../genres.service';

@Component({
  selector: 'app-genres',
  templateUrl: './genres.component.html',
  styleUrls: ['./genres.component.css']
})
export class GenresComponent implements OnInit {

  constructor(
    private route: ActivatedRoute,
    private productService: ProductService,
    private cartService: CartService,
    private genresService: GenresService
  ) { }

  books: Product[] = [];
  genre!: Genre;
  id!: number;

  ngOnInit(): void {
    this.getBooksByGenre();
    this.getGenreById();
  }

  getBooksByGenre(): void {
    const id = +this.route.snapshot.paramMap.get('id')!;
    this.productService.getBookByGenre(id)
      .subscribe(books => this.books = books);
  }

  addToCart(product: Product): void{
    this.cartService.addToCart(product);
  }

  getGenreById(): void {
    const id = + this.route.snapshot.paramMap.get('id')!;
    this.genresService.getGenreById(id)
      .subscribe(genre => this.genre = genre);
  }
}
