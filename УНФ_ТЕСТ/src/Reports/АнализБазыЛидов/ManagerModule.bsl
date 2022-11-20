#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	Вариант.Описание = НСтр("ru = 'Отчет предназначен для анализа имеющейся базы лидов по дате создания и ответственным менеджерам.'");
	Вариант.НастройкиДляПоиска.НаименованияПолей =
	НСтр("ru = 'Менеджер.'");
	Вариант.НастройкиДляПоиска.НаименованияПараметровИОтборов =
	НСтр("ru = 'Тег
	|Менеджер.'")
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли