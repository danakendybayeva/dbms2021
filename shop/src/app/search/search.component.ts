import { Component, OnInit } from '@angular/core';
import { Product} from '../products';
import { ProductService } from '../product.service';
import { ActivatedRoute } from '@angular/router';
import { CartService } from '../cart.service';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css']
})
export class SearchComponent implements OnInit {

  books: Product[] = [];

  constructor(private route: ActivatedRoute, private productService: ProductService, private cartService: CartService,) { }

  ngOnInit(): void {
    this.search();
  }

  search(): void{
    const text = this.route.snapshot.queryParams.text;
    this.productService.searchBook(text)
      .subscribe(books => this.books = books);
  }

  addToCart(product: Product): void{
    this.cartService.addToCart(product);
  }
}
