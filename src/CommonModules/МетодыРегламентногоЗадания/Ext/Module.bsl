﻿
Процедура ВыгрузкаВерсий() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Хранилища.Ссылка КАК Ссылка,
	               |	Хранилища.КоличествоВерсийВыгружаемыхВРегламентномЗадании КАК КоличествоВерсийВыгружаемыхВРегламентномЗадании
	               |ИЗ
	               |	Справочник.Хранилища КАК Хранилища
	               |ГДЕ
	               |	НЕ Хранилища.ПометкаУдаления
	               |	И Хранилища.ИспользоватьВРегламентномЗадании
	               |	И НЕ Хранилища.ВыполняетсяПроверкаАПК";  
	
	выборка = Запрос.Выполнить().Выбрать();
	
	Пока выборка.Следующий() Цикл
		
		Справочники.Хранилища.ЗагрузитьНовыеВерсии(выборка.Ссылка);
		Справочники.Хранилища.ВыгрузитьВерсииВЛокальныйРепозиторий(выборка.Ссылка, выборка.КоличествоВерсийВыгружаемыхВРегламентномЗадании);
		Справочники.Хранилища.ВыгрузитьВерсииВУдаленныйРепозиторий(выборка.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверкаАПК() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПроверкаАПК.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПроверкаАПК КАК ПроверкаАПК
	|ГДЕ
	|	НЕ ПроверкаАПК.ПометкаУдаления
	|	И ПроверкаАПК.ИспользоватьВРегламентномЗадании
	|	И НЕ ПроверкаАПК.Владелец.ПометкаУдаления";  
	
	выборка = Запрос.Выполнить().Выбрать();
	
	Пока выборка.Следующий() Цикл
		
		Справочники.ПроверкаАПК.ВыполнитьПроверку( выборка.Ссылка );
		
	КонецЦикла;
	
КонецПроцедуры
