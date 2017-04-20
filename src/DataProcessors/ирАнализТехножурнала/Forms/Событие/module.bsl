﻿
Процедура ЗначенияСвойствВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяРеквизита = ВыбраннаяСтрока.ИмяВТаблице;
	ТипЗначения = Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты[ИмяРеквизита].Тип;
	#Если Сервер И Не Сервер Тогда
	    ТипЗначения = Новый ОписаниеТипов();
	#КонецЕсли
	СтрокаСвойстваИнфобаза = ЗначенияСвойств.Найти("Инфобаза", "ИмяВТаблице");
	Если СтрокаСвойстваИнфобаза <> Неопределено Тогда
		Инфобаза = СтрокаСвойстваИнфобаза.Значение;
	КонецЕсли; 
	Если Истина
		И ирОбщий.СтрокиРавныЛкс(ПолучитьИмяСвойстваБезМета(ИмяРеквизита), "ТекстSDBL")
		И (Ложь
			Или Инфобаза = ""
			Или ирОбщий.СтрокиРавныЛкс(Инфобаза, НСтр(СтрокаСоединенияИнформационнойБазы(), "Ref")))
	Тогда
		СтрокаСвойстваИнфобаза = ЗначенияСвойств.Найти("ТекстSDBL", "ИмяВТаблице");
		Если СтрокаСвойстваИнфобаза <> Неопределено Тогда
			ТекстSDBL = СтрокаСвойстваИнфобаза.Значение;
			ОткрытьТекстБДВКонверторе(ТекстSDBL, Не ирОбщий.СтрокиРавныЛкс(ИмяРеквизита, "ТекстSDBL"));
		КонецЕсли; 
	ИначеЕсли Истина
		И ТипЗначения.СодержитТип(Тип("Строка"))
		И ТипЗначения.КвалификаторыСтроки.Длина = 0
	Тогда
		ВариантПросмотра = ПолучитьВариантПросмотраТекстПоИмениРеквизита(ИмяРеквизита);
		ирОбщий.ОткрытьТекстЛкс(ВыбраннаяСтрока.Значение, ВыбраннаяСтрока.СвойствоСиноним, ВариантПросмотра, Истина,
			"" + ЭтаФорма.КлючУникальности + ВыбраннаяСтрока.ИмяВТаблице);
	Иначе
		ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(Элемент, СтандартнаяОбработка);
	КонецЕсли; 

КонецПроцедуры

Процедура ПриОткрытии()
	
	ВыбраннаяСтрока = ЭтотОбъект.ТаблицаЖурнала.Найти(ЭтаФорма.КлючУникальности, "МоментВремени");
	ЗначенияСвойств.Очистить();
	ОбработкаНастройкиЖурнала = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирНастройкаТехножурнала");
	#Если Сервер И Не Сервер Тогда
		ОбработкаНастройкиЖурнала = Обработки.ирНастройкаТехножурнала.Создать();
	#КонецЕсли
	СписокСобытий = ОбработкаНастройкиЖурнала.ПолучитьСписокСобытий();
	СписокДействий = ОбработкаНастройкиЖурнала.ПолучитьСписокДействий();
	//СвойстваСобытия = ПолучитьСтруктуруСвойствСобытия(ВыбраннаяСтрока.Событие);
	СвойстваСобытия = ОбработкаНастройкиЖурнала.ПолучитьСтруктуруСвойствСобытия(ВыбраннаяСтрока.Событие);
	ТекущаяСтрокаСвойства = Неопределено;
	Для Каждого МетаРеквизит Из Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты Цикл
		ЗначениеСвойства = ВыбраннаяСтрока[МетаРеквизит.Имя];
		Если Ложь
			Или Не ЗначениеЗаполнено(ЗначениеСвойства) 
		Тогда
			Продолжить;
		КонецЕсли; 
		ОписаниеСвойства = "";
		ОсновоеИмяРеквизита = МетаРеквизит.Имя;
		ОсновоеИмяРеквизита = ПолучитьИмяСвойстваБезМета(ОсновоеИмяРеквизита);
		ВнутреннееИмя = ОсновоеИмяРеквизита;
		СтрокаВнутреннегоИмени = мТаблицаКолонок.Найти(ОсновоеИмяРеквизита, "ИмяВТаблице");
		Если СтрокаВнутреннегоИмени <> Неопределено Тогда
			ВнутреннееИмя = СтрокаВнутреннегоИмени.ВнутреннееИмя;
		КонецЕсли;
		СтрокаСвойстваСобытия = мСвойстваСобытий.Найти(НРег(СтрЗаменить(ВнутреннееИмя, ":", "_")), "НИмя");
		Если СтрокаСвойстваСобытия <> Неопределено Тогда
			Если Истина
				И Не СвойстваСобытия.Свойство(ОсновоеИмяРеквизита) 
				И ЗначениеСвойства = Ложь 
			Тогда 
				Продолжить;
			КонецЕсли; 
			ОписаниеСвойства = СтрокаСвойстваСобытия.Описание;
			Если ОсновоеИмяРеквизита <> МетаРеквизит.Имя Тогда
				ОписаниеСвойства = ОписаниеСвойства + " в терминах метаданных";
			КонецЕсли; 
		Иначе
			ВнутреннееИмя = "";
		КонецЕсли; 
		СтрокаСвойства = ЗначенияСвойств.Добавить();
		СтрокаСвойства.СвойствоСиноним = МетаРеквизит.Представление();
		СтрокаСвойства.СвойствоИмя = ВнутреннееИмя;
		СтрокаСвойства.ИмяВТаблице = МетаРеквизит.Имя;
		СтрокаСвойства.Значение = ЗначениеСвойства;
		СтрокаСвойства.ОписаниеСвойства = ОписаниеСвойства;
		Если ирОбщий.СтрокиРавныЛкс(ТекущееСвойство, МетаРеквизит.Имя) Тогда
			ТекущаяСтрокаСвойства = СтрокаСвойства;
		КонецЕсли;
		Если МетаРеквизит.Имя = "Событие" Тогда
			ОписаниеСобытия = СписокСобытий.НайтиПоЗначению(НРег(ВыбраннаяСтрока.Событие));
			Если ОписаниеСобытия <> Неопределено Тогда
				СтрокаСвойства = ЗначенияСвойств.Добавить();
				СтрокаСвойства.СвойствоСиноним = "Событие (описание)";
				СтрокаСвойства.Значение = ОписаниеСобытия.Представление;
			КонецЕсли; 
		КонецЕсли; 
		Если МетаРеквизит.Имя = "Действие" Тогда
			ОписаниеДействия = СписокДействий.НайтиПоЗначению(НРег(ВыбраннаяСтрока.Действие));
			Если ОписаниеДействия <> Неопределено Тогда
				СтрокаСвойства = ЗначенияСвойств.Добавить();
				СтрокаСвойства.СвойствоСиноним = "Действие (описание)";
				СтрокаСвойства.Значение = ОписаниеДействия.Представление;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если ТекущаяСтрокаСвойства <> Неопределено Тогда
		ЭлементыФормы.ЗначенияСвойств.ТекущаяСтрока = ТекущаяСтрокаСвойства;
	КонецЕсли; 
	
	ЭтаФорма.Заголовок = "Событие " + ВыбраннаяСтрока.Событие + " " + Формат(ВыбраннаяСтрока.МоментВремени, "ЧГ=");

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.Событие");
