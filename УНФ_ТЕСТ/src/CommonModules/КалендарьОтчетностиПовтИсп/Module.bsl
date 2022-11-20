#Область ПрограммныйИнтерфейс

///////////////////////////////////////////////////////////////////////////////
// Размещаются процедуры и функции для работы по разделу Календарь отчетности



// Функция возвращает начальный статус события календаря
// по виду задачи используемой в данном событии
// Начальный статус всегда равен НеНачато, 
// но дополнительная информация содержит комментарии, которые и возвращаются этой функцией
//
// Параметры:
//		СправочникСсылка.ЗадачиКалендаряПодготовкиОтчетности
//   Возвращает:
//		Строка
Функция ПолучитьНачальныйСтатусСобытияПоВидуЗадачи(Задача) Экспорт
	
	ВидЗадачи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Задача, "ВидЗадачи");
	
	Если ВидЗадачи = Перечисления.ВидыЗадачСобытийКалендаря.ЗаполнениеДанных Тогда
		Возврат НСтр("ru='Заполнить'");
	ИначеЕсли ВидЗадачи = Перечисления.ВидыЗадачСобытийКалендаря.Отчетность Тогда
		Возврат НСтр("ru='Сформировать'");
	ИначеЕсли ВидЗадачи = Перечисления.ВидыЗадачСобытийКалендаря.НалогиИВзносы Тогда
		Возврат НСтр("ru='Рассчитать'");
	КонецЕсли;
	
КонецФункции


Функция ПолучитьСтандартныйПериодДокументовДляСобытия(Событие) Экспорт
	
	Значения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Событие, "ДатаНачалаДокументов, ДатаОкончанияДокументов");
	Период = Новый СтандартныйПериод;
	Период.ДатаНачала = Значения.ДатаНачалаДокументов;
	Период.ДатаОкончания = КонецДня(Значения.ДатаОкончанияДокументов);
	
	Возврат Период;
	
КонецФункции

Функция ПолучитьМассивРасчетныхЗадач() Экспорт
	
	МассивРасчетныхЗадач = Новый Массив;
	
	МассивРасчетныхЗадач.Добавить(Справочники.ЗадачиКалендаряПодготовкиОтчетности.АвансовыйПлатежПоУСН);
	МассивРасчетныхЗадач.Добавить(Справочники.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалогЕНВД);
	МассивРасчетныхЗадач.Добавить(Справочники.ЗадачиКалендаряПодготовкиОтчетности.НалогиСотрудников);
	МассивРасчетныхЗадач.Добавить(Справочники.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыИП);
	МассивРасчетныхЗадач.Добавить(Справочники.ЗадачиКалендаряПодготовкиОтчетности.ЕдиныйНалог);
	МассивРасчетныхЗадач.Добавить(Справочники.ЗадачиКалендаряПодготовкиОтчетности.СтраховыеВзносыПриДоходахСвыше300тр);
	МассивРасчетныхЗадач.Добавить(Справочники.ЗадачиКалендаряПодготовкиОтчетности.НалогПатент);
	МассивРасчетныхЗадач.Добавить(Справочники.ЗадачиКалендаряПодготовкиОтчетности.ТорговыйСбор);
	
	Возврат  МассивРасчетныхЗадач;
	
КонецФункции

#КонецОбласти
