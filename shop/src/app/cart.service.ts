import { Injectable } from '@angular/core';
import { Observable, of} from 'rxjs';
import { Product } from './products';

@Injectable({
  providedIn: 'root'
})

export class CartService {
  items: Product[] = [];

  constructor() { }

  addToCart(product: Product): void {
    this.items.push(product);
  }

  getItems(): Observable<Product[]> {
    return of(this.items);
  }

  clearCart(): Product[] {
    this.items = [];
    return this.items;
  }
}
