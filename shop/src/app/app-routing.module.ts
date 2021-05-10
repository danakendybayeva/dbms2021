import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { BooksComponent } from './books/books.component';
import { CartComponent } from './cart/cart.component';
import { GenresComponent } from './genres/genres.component';
import { MainComponent } from './main/main.component';
import { SearchComponent} from './search/search.component';

const routes: Routes = [
  { path: '', component: MainComponent },
  { path: 'books', component: BooksComponent},
  { path: 'genre/:id', component: GenresComponent },
  { path: 'genre/:id/books', component: GenresComponent },
  { path: 'cart', component: CartComponent },
  { path: 'book/search/:text', component: SearchComponent },

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
