import requests
from bs4 import BeautifulSoup
import csv

URL = 'https://www.marwin.kz/books/business/'
# https://www.marwin.kz/psychological-literature/prakticheskaya-psihologiya/
# https://www.marwin.kz/psychological-literature/populyarnaya-psihologiya/
# https://www.marwin.kz/fiction/modern-prose/
# https://www.marwin.kz/fiction/molodjojnaya-literatura-18728/
# https://www.marwin.kz/books/business/
# https://www.marwin.kz/childrens-books/fairy-tales/
# https://www.marwin.kz/childrens-books/disney/
# https://www.marwin.kz/childrens-books/barbie-3/
# https://www.marwin.kz/books/kulinariya-18615/ 

FILE = 'books.csv'
FILE2 = 'genres.csv'

def get_html(url, params=None):
    r = requests.get(url, params=params)
    return r

def get_pages_count(html):
    soup = BeautifulSoup(html, 'html.parser')
    pages = soup.find_all('a', class_='page last' )
    if pages:
        return int(pages[-1].find('span', attrs={"itemprop": "name"}).text)
    else:
        return 1
        
def get_content(html):
    soup = BeautifulSoup(html, 'html.parser')
    items = soup.find_all('li', class_='item product product-item')
    books = []
    for item in items:
        book_detail = item.find('a', class_='product-item-link')['data-product-name']
        link = item.find('a', class_='product-item-link')['href']
        page2 = requests.get(link)
        soup2 = BeautifulSoup(page2.text, 'html.parser')
        details = soup2.find('div', class_='product info details notab')
        raiting = soup2.find('div', class_='rating-summary')
        desc = soup2.find('div', class_='product attribute description').p
        if desc:
            desc = desc.text
        else:
            desc = "Нет описания"
        books.append({
            'title': book_detail.split(': ')[-1],
            'author': book_detail.split(': ')[0],
            'genre': item.find('a', class_='product-item-link')['data-category'].split('/')[-1],
            'price': item.find('span', attrs={"data-price-type": "finalPrice"})['data-price-amount'],
            'id': item.find('a', class_='product-item-link')['data-id-product'],
            'link': link,
            'desc': desc,
            'raiting': raiting.find('span', class_='value').text,
            'img': item.find('img', class_='product-image-photo lazyload')['data-src']
        })
    return books

def get_genres(html):
    soup = BeautifulSoup(html, 'html.parser')
    items = soup.find_all('li', class_='item product product-item')
    genres = []
    for item in items:
        genres.append({
            'genre': item.find('a', class_='product-item-link')['data-category'].split('/')[-1]
        })
    return genres


def unique(list1):
    unique_list = []
    for x in list1:
        if x not in unique_list:
            unique_list.append(x)
    return unique_list

def save_file(items, path):
    with open(path, 'a', newline='', encoding="utf-16") as file:
        writer = csv.writer(file, delimiter=';')
        # writer.writerow(['ID', 'Название', 'Автор', 'Цена', 'Описание', 'Ссылка', 'Жанр', 'Рейтинг', 'Фото'])
        for item in items:
            writer.writerow([item['id'], item['title'], item['author'], item['price'], item['desc'], item['link'], item['genre'], item['raiting'], item['img']])

def save_genres(items, path):
    with open(path, 'a', newline='', encoding="utf-16") as file:
        writer = csv.writer(file, delimiter=';')
        # writer.writerow(['Genre'])
        for item in items:
            writer.writerow([item['genre']])

def parse():
    html = get_html(URL)
    books = []
    genres = []
    pages_count = get_pages_count(html.text)
    for page in range(1, pages_count + 1):
        print(f'Парсинг страницы {page} из {pages_count}...')
        html = get_html(URL, params={'p': page})
        books.extend(get_content(html.text))
        genres.extend(get_genres(html.text))
    print(f'Получено {len(books)} книг')
    unique_gen = unique(genres)
    save_file(books, FILE)
    save_genres(unique_gen, FILE2)

parse()
