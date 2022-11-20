
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиПоискаПоТоварам = ТорговыеПредложения.СохраненныеНастройкиПоискаПоТоварам();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиПоискаПоТоварам);
	Элементы.ПоискПоХарактеристике.Доступность = ПоискПоНаименованию;
	
	ДоступенПоискПоНоменклатуреСервиса = Ложь;
	Элементы.ПоискПоНоменклатуреСервиса.Видимость = ОбщегоНазначения.ПодсистемаСуществует(
		"ЭлектронноеВзаимодействие.РаботаСНоменклатурой");
	Если Элементы.ПоискПоНоменклатуреСервиса.Видимость Тогда
		МодульРаботаСНоменклатурой = ОбщегоНазначения.ОбщийМодуль("РаботаСНоменклатурой");
		ДоступенПоискПоНоменклатуреСервиса = МодульРаботаСНоменклатурой.ДоступнаФункциональностьПодсистемы();
	КонецЕсли;
	
	Если Не ДоступенПоискПоНоменклатуреСервиса Тогда
		Элементы.ПоискПоНоменклатуреСервиса.Доступность = Ложь;
		Если ПоискПоНоменклатуреСервиса = Истина Тогда
			Модифицированность = Истина;
			ПоискПоНоменклатуреСервиса = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПоискПоАртикулу И Не ПоискПоНаименованию И Не ПоискПоШтрихКоду И Не ПоискПоНоменклатуреСервиса Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите режим поиска'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриОтветеНаВопросОСохраненииИзмененныхДанных",
			ЭтотОбъект);
		
		ТекстВопроса = НСтр("ru = 'Данные модифицированы. Сохранить изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, 30);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИзменениеРежимаПоиска(Элемент)
	
	Модифицированность = Истина;
	Элементы.ПоискПоХарактеристике.Доступность = ПоискПоНаименованию;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПрименить(Команда)
	
	СохранитьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьНастройкиПоискаПоТоварам(НастройкиПоиска)
	
	ТорговыеПредложения.СохранитьНастройкиПоискаПоТоварам(НастройкиПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтветеНаВопросОСохраненииИзмененныхДанных(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьИЗакрыть();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть()
	
	НастройкиПоиска = Новый Структура;
	НастройкиПоиска.Вставить("ОграничениеТорговыхПредложений", ОграничениеТорговыхПредложений);
	НастройкиПоиска.Вставить("ПревышениеМинимальнойЦены",      ПревышениеМинимальнойЦены);
	НастройкиПоиска.Вставить("МаксимальныйСрокПоставки",       МаксимальныйСрокПоставки);
	НастройкиПоиска.Вставить("ПоискПоНаименованию",            ПоискПоНаименованию);
	НастройкиПоиска.Вставить("ПоискПоАртикулу",                ПоискПоАртикулу);
	НастройкиПоиска.Вставить("ПоискПоШтрихКоду",               ПоискПоШтрихКоду);
	НастройкиПоиска.Вставить("ПоискПоХарактеристике",          ПоискПоХарактеристике);
	НастройкиПоиска.Вставить("ПоискПоНоменклатуреСервиса",     ПоискПоНоменклатуреСервиса);
	СохранитьНастройкиПоискаПоТоварам(НастройкиПоиска);
	Модифицированность = Ложь;
	Закрыть(НастройкиПоиска);

КонецПроцедуры


#КонецОбласти