import { Component, OnInit } from '@angular/core';
import { Product } from '../products';
import { ProductService } from '../product.service';
import { CartService } from '../cart.service';

@Component({
  selector: 'app-books',
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css'],
  providers: [ProductService]
})
export class BooksComponent implements OnInit {

  books: Product[] = [];

  constructor(
    private productService: ProductService,
    private cartService: CartService,
  ) { }

  getBooks(): void{
    this.productService.getBooks()
      .subscribe(books => this.books = books);
  }

  ngOnInit(): void {
    this.getBooks();
  }

  addToCart(product: Product): void {
    this.cartService.addToCart(product);
  }

}
