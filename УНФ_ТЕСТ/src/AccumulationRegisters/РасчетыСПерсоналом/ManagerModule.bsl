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
	|	РасчетыСПерсоналом.НомерСтроки КАК НомерСтроки,
	|	РасчетыСПерсоналом.Организация КАК Организация,
	|	РасчетыСПерсоналом.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	РасчетыСПерсоналом.Сотрудник КАК Сотрудник,
	|	РасчетыСПерсоналом.Валюта КАК Валюта,
	|	РасчетыСПерсоналом.ПериодРегистрации КАК ПериодРегистрации,
	|	РасчетыСПерсоналом.Сумма КАК СуммаПередЗаписью,
	|	РасчетыСПерсоналом.Сумма КАК СуммаИзменение,
	|	РасчетыСПерсоналом.Сумма КАК СуммаПриЗаписи,
	|	РасчетыСПерсоналом.СуммаВал КАК СуммаВалПередЗаписью,
	|	РасчетыСПерсоналом.СуммаВал КАК СуммаВалИзменение,
	|	РасчетыСПерсоналом.СуммаВал КАК СуммаВалПриЗаписи
	|ПОМЕСТИТЬ ДвиженияРасчетыСПерсоналомИзменение
	|ИЗ
	|	РегистрНакопления.РасчетыСПерсоналом КАК РасчетыСПерсоналом");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыСПерсоналомИзменение", Ложь);
	
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