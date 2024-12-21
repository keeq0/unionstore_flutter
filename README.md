# Программирование корпоративных систем 
## Практическая работа №3 + №4 + №5 + №6
## Мякотных Сергей ЭФБО-02-22

Разработка мобильного приложения интернет-магазина кроссовок с использованием фреймворка Flutter.

## Мобильное приложение

В данном приложении представлен каталог товаров (обуви). У товара есть: бренд, название, цена, описание, артикул и т.д.

При нажатии на товар открывается его карточка с подробным описанием и характеристиками.

***Примечание***: некоторые элементы, такие как бургер-меню или поиск не работают, они сделаны для "целостности картины".

# Практические работы представлены ниже:

**Каталог, содержающий 10 товаров** (ПР №3)

<table>
  <tr>
    <th style="text-align: center;">Каталог с товарами</th>
  </tr>
  <tr>
    <td style="text-align: center;">
      https://github.com/user-attachments/assets/8930e08a-68e1-4f2f-9ff4-8dd8ece4decb
    </td>
  </tr>
</table>




**Удаление товара(ов) + Добавление товара(ов)** (ПР №4)

Добавлена функция удаления и добавления товаров в каталог.

<table align="center">
  <tr>
    <th style="text-align: center;">Удаление товара</th>
    <th style="text-align: center;">Добавление товара</th>
  </tr>
  <tr>
    <td style="text-align: center;">
        https://github.com/user-attachments/assets/0c56d448-cb16-4766-aaa3-ee2289254716
    </td>
    <td style="text-align: center;">
     https://github.com/user-attachments/assets/0628e8ad-58b4-4bae-8ba6-f3c61529d600
    </td>
  </tr>
</table>

**Навигационная панель** (ПР №5)

Добавлена навигационная панель с тремя вкладками: главная (каталог), избранное и профиль.

<table>
  <tr>
    <th style="text-align: center;">Навигационная панель (Главная, избранное, профиль)</th>
  </tr>
  <tr>
    <td style="text-align: center;">
        https://github.com/user-attachments/assets/dde13e2d-e788-4c0b-843a-ec9c1ff7ed14
    </td>
  </tr>
</table>

**Корзина и профиль** (ПР №6)

Добавлена вкладка "Корзина" и функция редактирования информации в профиле.

<table>
  <tr>
    <th style="text-align: center;">Корзина</th>
     <th style="text-align: center;">Редактирование профиля</th>
  </tr>
  <tr>
    <td style="text-align: center;">
      https://github.com/user-attachments/assets/23fc356e-fa3b-4e54-bd76-75d1683f7a35
    </td>
    <td style="text-align: center;">
      https://github.com/user-attachments/assets/e1f92e04-fd32-402d-91b8-b6f172dfcdc3
    </td>
  </tr>
</table>

## Разработка серверной части на языке Golang
**Практическая работа №8**

Структура backend части (/unionstore-backend):

![image](https://github.com/user-attachments/assets/39bf3df6-5969-412c-a741-8f93905da936)

Приложение получает данные с сервера по адресу:

```
  const String apiUrl = 'http://10.0.2.2:8080/products/...';
```

Вывод товаров по адресу *localhost:8080/products*:

![image](https://github.com/user-attachments/assets/0555512a-063a-41f3-925f-6e74fd0700f1)

<table>
  <tr>
    <th style="text-align: center;">Загрузка товаров с сервера</th>
  </tr>
  <tr>
    <td style="text-align: center;">
      https://github.com/user-attachments/assets/dc2ed59d-9505-4b85-b556-bdc70d2669d4
    </td>
  </tr>
</table>

**Практическая работа №9**

В данной практической работе я создал маршруты для серверной части:

> ```GET``` /products - Получить все продукты

> ```POST``` /products/create - Создать продукт

> ```DELETE``` /products/delete/{id} - Удалить продукт

> ```PUT``` /products/update/{id} - Обновление продукта

> ```GET``` /cart - Получить все элементы корзины

> ```POST``` /cart/add - Добавить продукт в корзину

> ```PATCH``` /cart/increase/{id} - Увеличить количество товара

> ```PATCH``` /cart/decrease/{id} - Уменьшить количество товара

> ```DELETE``` /cart/remove/{id} - Удалить товар из корзины

<table>
  <tr>
    <th style="text-align: center;">Добавление, редактирование, удаление товаров + корзина</th>
  </tr>
  <tr>
    <td style="text-align: center;">
  1    https://github.com/user-attachments/assets/9013a587-8991-4bd7-b5e4-e23a278c0749
    </td>
  </tr>
</table>
