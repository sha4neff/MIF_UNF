#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура создает пустую временную таблицу изменения движений.
//
// Параметры:
//  ДополнительныеСвойства	 - Структура - структура с ключами ДляПроведения.СтруктураВременныеТаблицы
//
Процедура СоздатьПустуюВременнуюТаблицуИзменение(ДополнительныеСвойства) Экспорт
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	СерийныеНомераКРасходу.НомерСтроки КАК НомерСтроки,
	|	СерийныеНомераКРасходу.Номенклатура КАК Номенклатура,
	|	СерийныеНомераКРасходу.Характеристика КАК Характеристика,
	|	СерийныеНомераКРасходу.Партия КАК Партия,
	|	СерийныеНомераКРасходу.СерийныйНомер КАК СерийныйНомер,
	|	СерийныеНомераКРасходу.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	СерийныеНомераКРасходу.Ячейка КАК Ячейка,
	|	СерийныеНомераКРасходу.Количество КАК КоличествоПередЗаписью,
	|	СерийныеНомераКРасходу.Количество КАК КоличествоИзменение,
	|	СерийныеНомераКРасходу.Количество КАК КоличествоПриЗаписи
	|ПОМЕСТИТЬ ДвиженияСерийныеНомераКРасходуИзменение
	|ИЗ
	|	РегистрНакопления.СерийныеНомераКРасходу КАК СерийныеНомераКРасходу");
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияСерийныеНомераКПоступлениюИзменение", Ложь);
	
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