
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоНалогов = Строка(Параметры.КоличествоНалогов);
	Параметры.Свойство("ТипСверки", ТипСверки);
	
	УдалитьДляИнтеграцииСБанком();
	ИзменитьДляТипаСверкиВЦеломПоОрганизации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(ПредопределенноеЗначение("Перечисление.КоличествоНалоговДляСверкиИОН." + КоличествоНалогов));
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УдалитьДляИнтеграцииСБанком()
	
	ФлагиУчета = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПолучитьФлагиИнтеграцииПоУмолчанию();
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиПереопределяемый.ПолучитьЗначенияКонстантИнтеграции(ФлагиУчета);
	
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.ИнтеграцияСБанком Тогда //Доступна и активна упрощенная отчетность
		ЭлВсе = Элементы.КоличествоНалогов.СписокВыбора.НайтиПоЗначению("Все");
		Если ЭлВсе <> Неопределено Тогда 
			Элементы.КоличествоНалогов.СписокВыбора.Удалить(ЭлВсе);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьДляТипаСверкиВЦеломПоОрганизации()
	
	// Запрещено выбирать налоги, так как нужно указывать ОКТМО для каждого КБК для каждого подразделения
	Если ТипСверки = Перечисления.ТипыСверокИОН.ВЦеломПоОрганизации Тогда
		
		ЭлОдин = Элементы.КоличествоНалогов.СписокВыбора.НайтиПоЗначению("Один");
		Если ЭлОдин <> Неопределено Тогда 
			Элементы.КоличествоНалогов.СписокВыбора.Удалить(ЭлОдин);
		КонецЕсли;
		
		ЭлНесколько = Элементы.КоличествоНалогов.СписокВыбора.НайтиПоЗначению("Несколько");
		Если ЭлНесколько <> Неопределено Тогда 
			ЭлНесколько.Представление = НСтр("ru = 'Несколько КБК'");
		КонецЕсли;
		
		ЭлВсе = Элементы.КоличествоНалогов.СписокВыбора.НайтиПоЗначению("Все");
		Если ЭлВсе <> Неопределено Тогда 
			ЭлВсе.Представление = НСтр("ru = 'Все КБК'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
