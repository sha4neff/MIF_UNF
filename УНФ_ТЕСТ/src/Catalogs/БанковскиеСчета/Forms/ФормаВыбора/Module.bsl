
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	УстановитьОтборНедействительные(ЭтотОбъект);
	
	Если Параметры.Свойство("РасчетыВУсловныхЕдиницах")
		И Параметры.РасчетыВУсловныхЕдиницах Тогда
		
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список,"Владелец",Параметры.Владелец);
		
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список,"ВалютаДенежныхСредств",Параметры.СписокВалют,Истина,ВидСравненияКомпоновкиДанных.ВСписке);
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		ТипВладельца = ТипЗнч(Параметры.Отбор.Владелец);
		Элементы.ПрямойОбмен.Видимость =
			ПолучитьФункциональнуюОпцию("ИспользоватьОбменСБанками") И ТипВладельца = Тип("СправочникСсылка.Организации");
	ИначеЕсли Параметры.Свойство("ПоказыватьВладельца") Тогда
		Элементы.ВладелецДляВыбораВКлиентБанке.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область НедействительныеЭлементыСписка

&НаКлиенте
Процедура ПоказыватьНедействительных(Команда)
	
	Элементы.ПоказыватьНедействительных.Пометка = Не Элементы.ПоказыватьНедействительных.Пометка;
	
	УстановитьОтборНедействительные(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// 1. Недействительная номенклатура отображается серым
	НовоеУсловноеОформление = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	
	Оформление = НовоеУсловноеОформление.Оформление.Элементы.Найти("ЦветТекста");
	Оформление.Значение 		= ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет;
	Оформление.Использование 	= Истина;
	
	Отбор = НовоеУсловноеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	Отбор.Использование 	= Истина;
	Отбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Недействителен");
	Отбор.ПравоеЗначение 	= Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборНедействительные(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Форма.Элементы.ПоказыватьНедействительных.Пометка);
	
КонецПроцедуры

#КонецОбласти
