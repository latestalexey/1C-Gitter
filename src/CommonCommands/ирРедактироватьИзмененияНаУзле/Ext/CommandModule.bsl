﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если ТонкийКлиент Или ВебКлиент Тогда
		Сообщить("Команда доступна только в толстом клиенте");
	#Иначе
		Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторИзмененийНаУзлах.Форма");
		Форма.ПараметрУзелОбмена = ПараметрКоманды;
		Форма.Открыть();
	#КонецЕсли 
	
КонецПроцедуры
