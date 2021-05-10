import { Injectable } from '@angular/core';
import { Observable, of} from 'rxjs';
import { GENRES} from './genres';
import { Genre} from './genre';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class GenresService {

  BASE_URL = 'http://localhost:4200';
  constructor(private http: HttpClient) { }

  genres = GENRES;

  getGenres(): Observable<Genre[]>{
    return this.http.get<Genre[]>(`${this.BASE_URL}/genre/all/`);
  }

  getGenreById(id: number): Observable<Genre>{
    return this.http.get<Genre>(`${this.BASE_URL}/genre/${id}/`);
  }
}
