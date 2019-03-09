drop database if exists newsletter;
create database newsletter;
use newsletter;

create table newstypes(
id int auto_increment primary key,
type varchar(50) not null unique);

create table users(
id int auto_increment primary key,
name varchar(100) not null unique,
pass varchar(100) not null,
role enum('reader', 'author', 'admin') default 'reader');

create table blobs(
id int auto_increment primary key,
pic blob(255) not null);

create table urls(
id int auto_increment primary key,
url varchar(255) not null);

create table articles(
id int auto_increment primary key,
title varchar(255) not null unique,
content text not null,
user_id int not null,
newstype_id int not null,
constraint foreign key(user_id) references users(id)
on update cascade,
constraint foreign key(newstype_id) references newstypes(id)
on update cascade
);

create table comments(
id int auto_increment primary key,
content text not null,
user_id int not null,
article_id int not null,
constraint foreign key(user_id) references users(id)
on update cascade,
constraint foreign key(article_id) references articles(id)
on update cascade
on delete cascade);

create table articles_blobs(
blob_id int not null,
article_id int not null,
constraint foreign key(blob_id) references blobs(id)
on delete cascade
on update cascade,
constraint foreign key(article_id) references articles(id)
on delete cascade
on update cascade,
primary key(blob_id, article_id));

create table articles_urls(
url_id int not null,
article_id int not null,
constraint foreign key(url_id) references urls(id)
on delete cascade
on update cascade,
constraint foreign key(article_id) references articles(id)
on delete cascade
on update cascade,
primary key(url_id, article_id));


insert into newstypes(type) values
('sport'), 
('national'), 
('world'), 
('weather');

insert into users(name, pass, role) values
('Angel98', 'pass1234', 'reader'),
('George', '1234pass', 'author'),
('Admin', 'YoLo', 'admin');

insert into blobs(pic) values
('test1'),
('test2');

insert into urls(url) values
('www.test1.com'),
('www.test2.bg');

insert into articles(title, content, newstype_id, user_id) values
('Levski - CSKA', '2 - 2', 1, 2),
('Weather Forecast 09.02.18', 'Warm and Sunny', 4, 3);

insert into comments(content, article_id, user_id) values
('Awesome', 2, 1),
('I will chill out in the park', 2, 1),
('lol', 1, 1),
('Thanks for subscribing', 2, 2);

insert into articles_blobs(blob_id, article_id) values (1,1), (2,2);

insert into articles_urls(url_id, article_id) values (1,1), (2,2), (2,1);

select title, newstypes.type, articles.content, users.name as 'author'
from articles 
join users on user_id=users.id 
join newstypes on newstype_id=newstypes.id 
order by (title);

select group_concat(type separator ' - ') from newstypes where type like 'w%';

select url from articles 
join articles_urls on articles_urls.article_id=articles.id
join urls on articles_urls.url_id=urls.id
where articles.title='Levski - CSKA';

select articles.title, concat_ws(': ', users.name, comments.content) as comments from articles
join comments on comments.article_id=articles.id
join users on comments.user_id=users.id 
where articles.id = 2;