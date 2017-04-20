﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	Справочники.Хранилища.ЗагрузитьНовыеВерсии(ПараметрКоманды);
	Справочники.Хранилища.ВыгрузитьВерсииВЛокальныйРепозиторий(ПараметрКоманды, ПараметрКоманды.КоличествоВерсийВыгружаемыхЗаРаз);	
	Справочники.Хранилища.ВыгрузитьВерсииВУдаленныйРепозиторий(ПараметрКоманды);
	#Иначе
	ВыгрузитьВерсииВРепозитории(ПараметрКоманды);
	#КонецЕсли
	
	ПоказатьОповещениеПользователя("Выгрузка в репозитории",,"Выгрузка в репозитории выполнена успешно");
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьВерсииВРепозитории(Хранилище)
	
	Справочники.Хранилища.ЗагрузитьНовыеВерсии(Хранилище);
	Справочники.Хранилища.ВыгрузитьВерсииВЛокальныйРепозиторий(Хранилище, Хранилище.КоличествоВерсийВыгружаемыхЗаРаз);	
	Справочники.Хранилища.ВыгрузитьВерсииВУдаленныйРепозиторий(Хранилище);
	
КонецПроцедуры

