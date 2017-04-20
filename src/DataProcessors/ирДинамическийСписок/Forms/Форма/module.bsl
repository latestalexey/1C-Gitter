﻿Перем мСвязанныйРедакторОбъектаБД;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура УстановитьОбъектМетаданных(ПолноеИмяТаблицы = Неопределено) Экспорт

	Если ПолноеИмяТаблицы <> Неопределено Тогда
		ЗначениеИзменено = Ложь;
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(ЭтаФорма.ОбъектМетаданных, ПолноеИмяТаблицы, ЗначениеИзменено);
		Если Не ЗначениеИзменено Тогда
			Возврат;
		КонецЕсли; 
	КонецЕсли; 
	ЭлементыФормы.ДинамическийСписок.ИзменятьСоставСтрок = Истина;
	МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ОбъектМетаданных);
	ОсновнойЭУ = ЭлементыФормы.ДинамическийСписок;
	ИмяТипаСписка = ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(ОбъектМетаданных, "Список");
	Если ЗначениеЗаполнено(ИмяТипаСписка) Тогда
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(ОбъектМетаданных);
		Если Истина
			И ЭтаФорма.Открыта()
			И ирОбщий.ЛиКорневойТипРегистраСведенийЛкс(МассивФрагментов[0]) 
			И ОбъектМД.Измерения.Количество() = 0
			И ОбъектМД.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический
			И ОбъектМД.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый
		Тогда
			// Антибаг платформы 8.3 Приложение аварийно завершалось
			ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов("ТаблицаЗначений");
			Сообщить("Списки независимых непериодических регистров сведений без измерений после открытия формы не подключаются из-за ошибки платформы");
		Иначе
			ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов(ИмяТипаСписка);
			ирОбщий.НастроитьАвтоТабличноеПолеДинамическогоСписка(ОсновнойЭУ);
			ЭтаФорма.Отбор = ЭлементыФормы.ДинамическийСписок.Значение.Отбор;
		КонецЕсли; 
	Иначе
		ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов("ТаблицаЗначений");
		Построитель.Текст = "ВЫБРАТЬ ПЕРВЫЕ 100000 РАЗРЕШЕННЫЕ Т.* ИЗ " + ОбъектМетаданных + " КАК Т";
		ОсновнойЭУ.Значение = Построитель.Результат.Выгрузить();
		ОсновнойЭУ.СоздатьКолонки();
		ОсновнойЭУ.ИзменятьСоставСтрок = Ложь;
		Для Каждого КолонкаТП Из ОсновнойЭУ.Колонки Цикл
			КолонкаТП.ТолькоПросмотр = Истина;
		КонецЦикла;
		Построитель.ЗаполнитьНастройки();
		КолонкаИдентификатора = ОсновнойЭУ.Колонки.Добавить("ИдентификаторЛкс");
		КолонкаИдентификатора.ТекстШапки = "Идентификатор ссылки";
		ЭтаФорма.Отбор = Построитель.Отбор;
	КонецЕсли;
	ПредставлениеТаблицы = ирОбщий.ПолучитьОписаниеТаблицыБДИис(ОбъектМетаданных).Представление;
	Для Каждого КолонкаТП Из ОсновнойЭУ.Колонки Цикл
		Если ТипЗнч(КолонкаТП.ЭлементУправления) = Тип("ПолеВвода") Тогда
			КолонкаТП.ЭлементУправления.УстановитьДействие("ОкончаниеВводаТекста", Новый Действие("ПолеВводаКолонкиСписка_ОкончаниеВводаТекста"));
			КолонкаТП.ЭлементУправления.УстановитьДействие("НачалоВыбора", Новый Действие("ПолеВводаКолонкиСписка_НачалоВыбора"));
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ПредставлениеТаблицы, ": ");
	Если РежимВыбора Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (выбор)";
	КонецЕсли; 
	КорневойТип = ирОбщий.ПолучитьПервыйФрагментЛкс(ОбъектМетаданных);
	ЭтоПеречисление = ирОбщий.ЛиКорневойТипПеречисленияЛкс(КорневойТип);
	//ЭлементыФормы.КП_Список.Кнопки.РедакторОбъектаБДСтроки.Доступность = Не ЭтоПеречисление;
	//ЭлементыФормы.КП_Список.Кнопки.РедакторОбъектаБДЯчейки.Доступность = Не ЭтоПеречисление;
	ЭтаФорма.ВместоОсновной = ирОбщий.ПолучитьИспользованиеДинамическогоСпискаВместоОсновнойФормыЛкс(ОбъектМетаданных);
	Попытка
		ЭлементыФормы.ДинамическийСписок.Колонки.Наименование.ОтображатьИерархию = Истина;
		ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.ОтображатьИерархию = Ложь;
		ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.Видимость = Ложь;
	Исключение
	КонецПопытки;
	ЭлементыФормы.КоманднаяПанельПереключателяДерева.Кнопки.РежимДерева.Доступность = ирОбщий.ЛиМетаданныеИерархическогоОбъектаЛкс(ОбъектМД);
	
КонецПроцедуры

Процедура НайтиСсылкуВСписке(КлючСтроки, УстановитьОбъектМетаданных = Истина) Экспорт

	МетаданныеТаблицы = Метаданные.НайтиПоТипу(ТипЗнч(КлючСтроки));
	Если УстановитьОбъектМетаданных Тогда
		УстановитьОбъектМетаданных(МетаданныеТаблицы.ПолноеИмя());
	КонецЕсли; 
	ИмяXMLТипа = СериализаторXDTO.XMLТипЗнч(КлючСтроки).ИмяТипа;
	Если Ложь
		Или Найти(ИмяXMLТипа, "Ref.") > 0
		Или Найти(ИмяXMLТипа, "RecordKey.") > 0
	Тогда
		ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = КлючСтроки;
	Иначе
		ирОбщий.СкопироватьОтборДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок.Значение.Отбор, КлючСтроки.Отбор);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Форма = ирКэш.Получить().ПолучитьФорму("ВыборОбъектаМетаданных", Элемент, ЭтаФорма);
	лСтруктураПараметров = Новый Структура;
	лСтруктураПараметров.Вставить("НачальноеЗначениеВыбора", ОбъектМетаданных);
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Истина);
	лСтруктураПараметров.Вставить("ОтображатьПеречисления", Истина);
	лСтруктураПараметров.Вставить("ОтображатьВыборочныеТаблицы", Истина);
	лСтруктураПараметров.Вставить("ОтображатьРегистры", Истина);
	лСтруктураПараметров.Вставить("ОтображатьПерерасчеты", Ложь);
	лСтруктураПараметров.Вставить("ОтображатьПоследовательности", Ложь);
	Форма.НачальноеЗначениеВыбора = лСтруктураПараметров;
	Форма.ОткрытьМодально();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбъектМетаданныхОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура КП_СписокОткрытьУниверсальныйОтбор(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок, ЭтаФорма);

КонецПроцедуры

Процедура КП_СписокСжатьКолонки(Кнопка)
	
	ирОбщий.СжатьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭтаФорма.СвязиИПараметрыВыбора = Истина;
	Если КлючУникальности <> Неопределено Тогда
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(КлючУникальности);
		Если ОбъектМД <> Неопределено Тогда
			УстановитьОбъектМетаданных(КлючУникальности);
		КонецЕсли;
	КонецЕсли; 
	Если Истина
		И ЗначениеЗаполнено(ОбъектМетаданных)
		И НачальноеЗначениеВыбора <> Неопределено 
		И ЗначениеЗаполнено(НачальноеЗначениеВыбора) 
	Тогда
		Если Ложь
			Или ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора)
			Или ирОбщий.ЛиСсылкаНаПеречислениеЛкс(НачальноеЗначениеВыбора)
		Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = НачальноеЗначениеВыбора;
		ИначеЕсли ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора, Ложь) Тогда 
			ТекущаяСтрока = ЭлементыФормы.ДинамическийСписок.Значение.Найти(НачальноеЗначениеВыбора, "Ссылка");
			Если ТекущаяСтрока <> Неопределено Тогда
				ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = ТекущаяСтрока;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	Если ЗначениеЗаполнено(ОбъектМетаданных) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ДинамическийСписок;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СписокШиринаКолонок(Кнопка)
	
	ирОбщий.РасширитьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура КП_СписокРедакторОбъектаБДСтроки(Кнопка)
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок, ОбъектМетаданных);
	
КонецПроцедуры

Процедура КП_СписокОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДинамическийСписокПриПолученииДанных(Элемент, ОформленияСтрок)
	
	КолонкаИдентфиикатор = Элемент.Колонки.Найти("ИдентификаторЛкс");
	Если КолонкаИдентфиикатор <> Неопределено Тогда
		КолонкаИдентификатораВидима = КолонкаИдентфиикатор.Видимость;
	Иначе
		КолонкаИдентификатораВидима = Ложь;
	КонецЕсли; 
	КолонкаЭтоГруппа = Элемент.Колонки.Найти("ЭтоГруппа");
	Если Истина
		И КолонкаЭтоГруппа <> Неопределено 
		И КолонкаЭтоГруппа.Данные = ""
		И КолонкаЭтоГруппа.ДанныеФлажка = ""
	Тогда
		// Антибаг платформы 8.2-8.3.9 В свойство Данные и ДанныеФлажка нельзя записать "ЭтоГруппа", поэтому выводим значение в ячейки сами
		КолонкаЭтоГруппаВидима = КолонкаЭтоГруппа.Видимость;
	Иначе
		КолонкаЭтоГруппаВидима = Ложь;
	КонецЕсли; 
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
		Если ДанныеСтроки = неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если КолонкаИдентификатораВидима Тогда
			ЯчейкаИдентификатора = ОформлениеСтроки.Ячейки["ИдентификаторЛкс"];
			Если ЭтоПеречисление Тогда
				ИдентфикаторСсылки = "" + XMLСтрока(ДанныеСтроки);
			Иначе
				ИдентфикаторСсылки = "" + ирОбщий.ПолучитьИдентификаторСсылкиЛкс(ДанныеСтроки.Ссылка);
			КонецЕсли; 
			ЯчейкаИдентификатора.УстановитьТекст(ИдентфикаторСсылки);
		КонецЕсли;
		Если КолонкаЭтоГруппаВидима Тогда
			ЯчейкаИдентификатора = ОформлениеСтроки.Ячейки["ЭтоГруппа"];
			ЯчейкаИдентификатора.Значение = ДанныеСтроки.ЭтоГруппа;
		КонецЕсли;
		Если Истина
			И Не ЭтоПеречисление
			И Элемент.Значение.Колонки.Найти("Активность") <> Неопределено
			И ДанныеСтроки.Активность = Ложь 
		Тогда
			ОформлениеСтроки.ЦветТекста = Новый Цвет(100, 100, 100);
		КонецЕсли; 
		ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КП_Список.Кнопки.Идентификаторы);
	КонецЦикла;

КонецПроцедуры

Процедура КП_СписокОбъединитьСсылки(Кнопка)
	
	ПараметрКоманды = ЭлементыФормы.ДинамическийСписок.ВыделенныеСтроки;
	Если ПараметрКоманды.Количество() = 0 Тогда
		Предупреждение("Необходимо выбрать хотя бы один объект");
		Возврат;
	КонецЕсли; 
	ФормаОбработки = ирОбщий.ПолучитьФормуЛкс("Обработка.ирПоискДублейИЗаменаСсылок.Форма");
	ФормаОбработки.ОткрытьДляЗаменыПоСпискуСсылок(ПараметрКоманды);
	
КонецПроцедуры

Процедура КП_СписокОбработатьОбъекты(Кнопка)
	
	ирОбщий.ОткрытьПодборИОбработкуОбъектовИзТабличногоПоляДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура КП_СписокОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура ОбъектМетаданныхПриИзменении(Элемент)
	
	УстановитьОбъектМетаданных();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя);
	
КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);

КонецПроцедуры

Процедура ОбъектМетаданныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		лПолноеИмяОбъекта = Неопределено;
		Если ВыбранноеЗначение.Свойство("ПолноеИмяОбъекта", лПолноеИмяОбъекта) Тогда
			ОбъектМетаданных = ВыбранноеЗначение.ПолноеИмяОбъекта;
			ОбъектМетаданныхПриИзменении(Элемент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КП_СписокСколькоСтрок(Кнопка)
	
	ирОбщий.ТабличноеПоле_СколькоСтрокЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	
	УстановитьОбъектМетаданных();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЗначениеТабличногоПоля = ЭлементыФормы.ДинамическийСписок.Значение;
	Попытка
		ПредставлениеОтбора = "" + ЗначениеТабличногоПоля.Отбор;
	Исключение
		ПредставлениеОтбора = "";
	КонецПопытки; 
	Если ПредставлениеОтбора = "" Тогда
		ПредставлениеОтбора = "нет";
	КонецЕсли; 
	ЭлементыФормы.НадписьОтбор.Заголовок = "Отбор: " + ПредставлениеОтбора;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписанОбъект" Тогда
		ОбъектМД = Метаданные.НайтиПоТипу(Параметр);
		Если ОбъектМД <> Неопределено Тогда
			Если ОбъектМД.ПолноеИмя() = ОбъектМетаданных Тогда
				ЭлементыФормы.ДинамическийСписок.Значение.Обновить();
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДинамическийСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		Если ирОбщий.ПолучитьТипТаблицыБДЛкс(ОбъектМетаданных) = "Точки" Тогда
			Если ТипЗнч(ВыбраннаяСтрока) = Тип("Массив") Тогда
				Массив = Новый Массив;
				Для Каждого ЭлементМассива Из ВыбраннаяСтрока Цикл
					Массив.Добавить(ЭлементМассива.Ссылка);
				КонецЦикла;
			Иначе
				Массив = ВыбраннаяСтрока.Ссылка;
			КонецЕсли; 
			ОповеститьОВыборе(Массив);
		Иначе
			ОповеститьОВыборе(ВыбраннаяСтрока);
		КонецЕсли; 
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СписокВыбратьНужноеКоличество(Кнопка)
	
	Количество = 0;
	Если Не ВвестиЧисло(Количество, "Введите количество", 6, 0) Тогда
		Возврат;
	КонецЕсли; 
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли; 
	Построитель = Новый ПостроительЗапроса;
	Построитель.Текст = "ВЫБРАТЬ ПЕРВЫЕ " + XMLСтрока(Количество) + " * ИЗ " + ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ОбъектМетаданных) + " КАК Т";
	Построитель.ЗаполнитьНастройки();
	ирОбщий.СкопироватьОтборДинамическогоСпискаЛкс(Построитель.Отбор, ЭлементыФормы.ДинамическийСписок.Значение.Отбор);
	ирОбщий.СкопироватьПорядокЛкс(Построитель.Порядок, ЭлементыФормы.ДинамическийСписок.Значение.Порядок);
	Выборка = Построитель.Результат.Выбрать();
	ВыделенныеСтроки = ЭлементыФормы.ДинамическийСписок.ВыделенныеСтроки;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Выборка.Количество(), "Выделение");
	Пока Выборка.Следующий() Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ВыделенныеСтроки.Добавить(ирОбщий.ПолучитьКлючСтрокиТаблицыБДИзСтрокиТаблицыЗначенийЛкс(ОбъектМетаданных, Выборка));
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если Выборка.Количество() <> Количество Тогда
		Сообщить("Выделены все отобранные элементы, но меньшим количеством " + XMLСтрока(Выборка.Количество()));
	КонецЕсли; 
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КП_СписокКопироватьСсылку(Кнопка)
	
	ТекущийЭлементФормы = ЭлементыФормы.ДинамическийСписок;
	ТекущаяСтрока = ТекущийЭлементФормы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирОбщий.БуферОбмена_УстановитьЗначениеЛкс(ТекущаяСтрока);
	
КонецПроцедуры

Процедура КП_СписокЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура КП_СписокИдентификаторы(Кнопка)
	
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ЭлементыФормы.ДинамическийСписок.ОбновитьСтроки();
	
КонецПроцедуры

Процедура ДинамическийСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель = Неопределено, ЭтоГруппа = Неопределено)
	
	Ответ = Вопрос("Использовать редактор объекта БД?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(ОбъектМетаданных);
		Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ирОбщий.ПолучитьПервыйФрагментЛкс(ОбъектМетаданных)) Тогда
			Если Копирование Тогда
				ОбъектБД = Элемент.ТекущаяСтрока.Скопировать();
			Иначе
				ЭтоГруппа = Ложь
					Или ЭтоГруппа = Истина
					Или (Истина
						И ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(ОбъектМД)
						И ЭлементыФормы.ДинамическийСписок.Значение.Отбор.ЭтоГруппа.Использование = Истина
						И ЭлементыФормы.ДинамическийСписок.Значение.Отбор.ЭтоГруппа.ВидСравнения = ВидСравнения.Равно
						И ЭлементыФормы.ДинамическийСписок.Значение.Отбор.ЭтоГруппа.Значение = Истина);
				ОбъектБД = ирОбщий.СоздатьСсылочныйОбъектПоМетаданнымЛкс(ОбъектМД, ЭтоГруппа);
			КонецЕсли; 
			ирОбщий.УстановитьЗначенияРеквизитовПоОтборуЛкс(ОбъектБД, ЭлементыФормы.ДинамическийСписок.Значение.Отбор);
			ирОбщий.ОткрытьОбъектВРедактореОбъектаБДЛкс(ОбъектБД);
		Иначе
			КлючОбъекта = Новый (СтрЗаменить(ОбъектМетаданных, ".", "НаборЗаписей."));
			Для Каждого ЭлементОтбора Из КлючОбъекта.Отбор Цикл
				ЭлементОтбора.Использование = Истина;
			КонецЦикла;
			ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючОбъекта);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура КП_СписокСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПолеВводаКолонкиСписка_НачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ТабличноеПоле = ЭлементыФормы.ДинамическийСписок;
	Если СвязиИПараметрыВыбора Тогда
		ИмяПоляТаблицы = ТабличноеПоле.ТекущаяКолонка.Имя;
		ПоляТаблицыБД = ирКэш.ПолучитьПоляТаблицыБДЛкс(ОбъектМетаданных);
		МетаРеквизит = ПоляТаблицыБД.Найти(ИмяПоляТаблицы, "Имя").Метаданные;
		СтруктураОтбора = ирОбщий.ПолучитьСтруктуруОтбораПоСвязямИПараметрамВыбораЛкс(ТабличноеПоле.ТекущиеДанные, МетаРеквизит);
	КонецЕсли; 
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ТабличноеПоле, СтандартнаяОбработка,, Истина, СтруктураОтбора);

КонецПроцедуры

Процедура ПолеВводаКолонкиСписка_ОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КП_СписокРедакторОбъектаБДЯчейки(Кнопка)
	
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура КП_СписокОсновнаяФорма(Кнопка)
	
	ЭтаФорма.Закрыть();
	Форма = ирОбщий.ОткрытьФормуСпискаЛкс(ОбъектМетаданных, ЭлементыФормы.ДинамическийСписок.Значение.Отбор, Ложь, ЭтаФорма.ВладелецФормы, ЭтаФорма.РежимВыбора, МножественныйВыбор,
		ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока);
	Если Форма = Неопределено Тогда
		ЭтаФорма.Открыть();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВместоОсновнойПриИзменении(Элемент)
	
	СохранитьЗначение("ирДинамическийСписок.ВместоОсновной." + ОбъектМетаданных, ЭтаФорма.ВместоОсновной);

КонецПроцедуры

Процедура КП_СписокСвязанныйРедакторОбъектаБДСтроки(Кнопка)

	Если ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	
КонецПроцедуры

Процедура ДинамическийСписокПриАктивизацииСтроки(Элемент)
	
	Если мСвязанныйРедакторОбъектаБД <> Неопределено И мСвязанныйРедакторОбъектаБД.Открыта() Тогда
		ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьСвязанныйРедакторОбъектаБДСтроки()
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок, ОбъектМетаданных,, Истина, мСвязанныйРедакторОбъектаБД);

КонецПроцедуры

Процедура КП_СписокРежимДерева(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	Если Кнопка.Пометка Тогда
		Попытка
			ЭлементыФормы.ДинамическийСписок.ИерархическийПросмотр = Истина;
		Исключение
		КонецПопытки;
	КонецЕсли;
	Попытка
		Если ЭлементыФормы.ДинамическийСписок.Дерево <> Кнопка.Пометка Тогда
			ЭлементыФормы.ДинамическийСписок.Дерево = Кнопка.Пометка;
		КонецЕсли;
	Исключение
	КонецПопытки;
	Попытка
		ЭлементыФормы.ДинамическийСписок.ИерархическийПросмотр = Истина;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура КП_СписокОбновить(Кнопка)
	
	ЭлементыФормы.ДинамическийСписок.Значение.Обновить();
	
КонецПроцедуры

Процедура КП_СписокСправкаМетаданного(Кнопка)
	
	ОткрытьСправку(Метаданные.НайтиПоПолномуИмени(ОбъектМетаданных));
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирДинамическийСписок.Форма.Форма");
Если КлючУникальности = "Связанный" Тогда
	ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (связанный)";
КонецЕсли;
