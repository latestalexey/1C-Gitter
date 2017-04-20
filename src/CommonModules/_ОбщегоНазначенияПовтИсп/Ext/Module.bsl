﻿
Функция ДанныеМетаданных() Экспорт

	данные = Новый Соответствие;
	
	СтруктВставить( данные, "AccumulationRegisters", "РегистрыНакопления", "Регистр накомления" );
	СтруктВставить( данные, "BusinessProcesses", "БизнесПроцессы", "Бизнес процесс" );
	СтруктВставить( данные, "Catalogs", "Справочники", "Справочник" );
	СтруктВставить( данные, "ChartsOfCharacteristicTypes", "ПланыВидовХарактеристик", "План видов характеристик" );
	СтруктВставить( данные, "CommonCommands", "Общие.ОбщиеКоманды", "Общая команда" );
	СтруктВставить( данные, "CommonForms", "Общие.ОбщиеФормы", "Общая управляемая форма" );
	СтруктВставить( данные, "CommonModules", "Общие.ОбщиеМодули", "Общий модуль" );
	СтруктВставить( данные, "CommonTemplates", "Общие.ОбщиеМакеты", "Общий макет" );
	СтруктВставить( данные, "Constants", "Константы", "Константа" );
	СтруктВставить( данные, "DataProcessors", "Обработки", "Обработка" );
	СтруктВставить( данные, "DocumentJournals", "ЖурналыДокументов", "ЖурналДокументов" );
	СтруктВставить( данные, "Documents", "Документы", "Документ" );
	СтруктВставить( данные, "Enums", "Перечисления", "Перечисление" );
	СтруктВставить( данные, "InformationRegisters", "РегистрыСведений", "Регистр сведений" );
	СтруктВставить( данные, "Reports", "Отчеты", "Отчет" );
	СтруктВставить( данные, "Roles", "Общие.Роли", "Роль" );
	СтруктВставить( данные, "ScheduledJobs", "РегламентныеЗадания", "Регламентное задание" );
	СтруктВставить( данные, "Tasks", "Задачи", "Задача" );

	Возврат данные;

КонецФункции // СоответствиеМетаданных()

Процедура СтруктВставить( структ, Знач пКлюч, Знач пИмяОбъекта, Знач пТипОбъекта)

	структ.Вставить( пКлюч, Новый Структура("Имя,Тип", пИмяОбъекта, пТипОбъекта ) );

КонецПроцедуры

