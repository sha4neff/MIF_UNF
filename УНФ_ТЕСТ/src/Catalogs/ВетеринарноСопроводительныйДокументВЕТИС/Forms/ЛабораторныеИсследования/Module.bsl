

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЛабораторныеИсследования") Тогда
		Для каждого Строка Из Параметры.ЛабораторныеИсследования Цикл
			ЗаполнитьЗначенияСвойств(ЛабораторныеИсследования.Добавить(), Строка);
		КонецЦикла;
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЛабораторныеИсследования

&НаКлиенте
Процедура ЛабораторныеИсследованияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтаФорма, "ЛабораторныеИсследования");
	
КонецПроцедуры

&НаКлиенте
Процедура ЛабораторныеИсследованияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	СформироватьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура ЛабораторныеИсследованияПослеУдаления(Элемент)
	СформироватьЗаголовокФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	СохранитьИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьИзменения();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения()
	
	СтруктураПроверяемыхПолей = Новый Структура;
	СтруктураПроверяемыхПолей.Вставить("НаименованиеЛаборатории", НСтр("ru='Наименование лаборатории'"));
	СтруктураПроверяемыхПолей.Вставить("НаименованиеПоказателя", НСтр("ru='Наименование показателя'"));
	СтруктураПроверяемыхПолей.Вставить("ДатаПолученияРезультата", НСтр("ru='Дата получения результата'"));
	СтруктураПроверяемыхПолей.Вставить("НомерЭкспертизы", НСтр("ru='Номер экспертизы'"));
	СтруктураПроверяемыхПолей.Вставить("РезультатИсследования", НСтр("ru='Результат'"));
	СтруктураПроверяемыхПолей.Вставить("Заключение");
	
	Если ИнтеграцияВЕТИСКлиент.ПроверитьЗаполнениеТаблицы(ЭтаФорма, "ЛабораторныеИсследования", СтруктураПроверяемыхПолей) Тогда
		Модифицированность = Ложь;
		ОповеститьОВыборе(ЛабораторныеИсследования);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаголовокФормы()
	
	Заголовок = НСтр("ru = 'Лабораторные исследования'")
		+ ?(ЛабораторныеИсследования.Количество()," ("+ЛабораторныеИсследования.Количество()+")","");
	
КонецПроцедуры

#КонецОбласти