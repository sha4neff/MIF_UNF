////////////////////////////////////////////////////////////////////////////////
// Проверка контрагентов в Декларации по НДС
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Процедура - Действия при открытии декларации по НДС.
//		Подключение обработчика ожидания для того, чтобы сразу после открытия декларации по НДС
//		показать предложение подключиться к проверке контрагентов.
//
// Параметры:
//  Форма	 - ФормаКлиентскогоПриложения - Форма декларации по НДС с 2015 г.
//  СтандартнаяОбработка - Булево - Если истина, то выполняется стандартная процедура.
//		Значение по умолчанию - Истина.
Процедура ПриОткрытииДекларацияПоНДС(Форма, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Процедура - Показывает предложение включить проверку при автозаполнении декларации по НДС.
//		Если проверка включена, то предложение не отображается.
//
// Параметры:
//  Форма	 					- ФормаКлиентскогоПриложения - Форма декларации по НДС с 2015 г.
//  СтандартнаяОбработка 		- Булево - Если истина, то выполняется стандартная процедура.
//		Значение по умолчанию - Истина.
Процедура ПоказатьПредложениеВключитьПроверкуКонтрагентовПередЗаполнением(Форма, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти
