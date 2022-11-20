#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда	
		Возврат;		
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	СтраховыеВзносыПереданныеВПФР.НомерСтроки КАК НомерСтроки,
	|	СтраховыеВзносыПереданныеВПФР.ВидДвижения КАК ВидДвижения,
	|	СтраховыеВзносыПереданныеВПФР.Организация КАК Организация,
	|	СтраховыеВзносыПереданныеВПФР.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СтраховыеВзносыПереданныеВПФР.КатегорияЗастрахованныхЛиц КАК КатегорияЗастрахованныхЛиц,
	|	СтраховыеВзносыПереданныеВПФР.Страховая КАК СтраховаяПередЗаписью,
	|	СтраховыеВзносыПереданныеВПФР.Страховая КАК СтраховаяИзменение,
	|	СтраховыеВзносыПереданныеВПФР.Страховая КАК СтраховаяПриЗаписи,
	|	СтраховыеВзносыПереданныеВПФР.Накопительная КАК НакопительнаяПередЗаписью,
	|	СтраховыеВзносыПереданныеВПФР.Накопительная КАК НакопительнаяИзменение,
	|	СтраховыеВзносыПереданныеВПФР.Накопительная КАК НакопительнаяПриЗаписи
	|ПОМЕСТИТЬ ДвиженияСтраховыеВзносыПереданныеВПФРИзменение
	|ИЗ
	|	РегистрНакопления.СтраховыеВзносыПереданныеВПФР КАК СтраховыеВзносыПереданныеВПФР");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияСтраховыеВзносыПереданныеВПФРИзменение", Ложь);
	
КонецПроцедуры // СоздатьПустуюВременнуюТаблицуИзменение()

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли