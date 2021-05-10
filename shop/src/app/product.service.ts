import { Injectable, Inject } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { Product } from './products';
import { books } from './books';
import { GENRES } from './genres';

@Injectable({
  providedIn: 'root'
})
export class ProductService {

    books = books;
    genres = GENRES;
    BASE_URL = 'http://localhost:4200';

  constructor(private http: HttpClient) { }

  getBooks(): Observable<Product[]>{
    return of(books);
    // return this.http.get<Product[]>(`${this.BASE_URL}/book/all/`);
  }
  getBookById(id: number): Observable<Product>{
    return this.http.get<Product>(`${this.BASE_URL}/book/${id}/`);
    // return of(books.find(book => book.id === id));
  }

  getBookByGenre(id: number): Observable<Product[]>{
    return this.http.get<Product[]>(`${this.BASE_URL}/genre/${id}/books/`);
  }

  searchBook(term: string): Observable<Product[]> {
    return this.http.get<Product[]>(`${this.BASE_URL}/book/search/${term}`);
  }
}
