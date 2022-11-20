&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаПерейдитеНаПлатныйТариф = АдресСтраницыТарифов(Параметры);
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(СсылкаПерейдитеНаПлатныйТариф);
	
	Соединение = Новый HTTPСоединение(СтруктураURI.ИмяСервера,,,,,, ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение());
	СтраницаСТарифами = Соединение.Получить(Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере)).ПолучитьТелоКакСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеHTMLДокументаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДанныеСобытия.Href <> Неопределено Тогда
		
		Если СтрНайти(ВРег(ДанныеСобытия.Href), "TARIF") = 0 Тогда
			СтандартнаяОбработка = Истина;
			Возврат;
		КонецЕсли; 
		
		СтандартнаяОбработка = Ложь;
		
		Тариф = СокрЛП(СтрЗаменить(ДанныеСобытия.Href, "Tarif:", ""));
		Тариф = СокрЛП(СтрЗаменить(ДанныеСобытия.Href, "tarif:", ""));
		
		Закрыть(Тариф);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция АдресСтраницыТарифов(Параметры)
	
	СсылкаПерейдитеНаПлатныйТариф = Параметры.СсылкаПерейдитеНаПлатныйТариф;
	
	СправаЕстьСлеш = Прав(СсылкаПерейдитеНаПлатныйТариф, 1) = "/";
	Если СправаЕстьСлеш Тогда
		ДлинаСсылки = СтрДлина(СсылкаПерейдитеНаПлатныйТариф);
		СсылкаПерейдитеНаПлатныйТариф = Лев(СсылкаПерейдитеНаПлатныйТариф, ДлинаСсылки - 1);
	КонецЕсли;
	
	СсылкаПерейдитеНаПлатныйТариф = СсылкаПерейдитеНаПлатныйТариф + "-select";
	
	Если СправаЕстьСлеш Тогда
		СсылкаПерейдитеНаПлатныйТариф = СсылкаПерейдитеНаПлатныйТариф + "/";
	КонецЕсли;
	
	Возврат СсылкаПерейдитеНаПлатныйТариф;
	
КонецФункции

#КонецОбласти

