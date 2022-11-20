#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура УстановитьЗначение(ЗначениеСчетчика) Экспорт
	
	ИдентификаторПриложения = ПолучитьИдентификаторПриложения();
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИдентификаторПриложения = ИдентификаторПриложения;
	МенеджерЗаписи.КоличествоЗапусков = ЗначениеСчетчика;
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

Функция ПолучитьЗначение() Экспорт
	
	ИдентификаторПриложения = ПолучитьИдентификаторПриложения();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СчетчикДляОткрытияФормыОценкиМобильногоКлиента.ИдентификаторПриложения КАК ИдентификаторПриложения,
	|	СчетчикДляОткрытияФормыОценкиМобильногоКлиента.КоличествоЗапусков КАК КоличествоЗапусков
	|ИЗ
	|	РегистрСведений.СчетчикДляОткрытияФормыОценкиМобильногоКлиента КАК СчетчикДляОткрытияФормыОценкиМобильногоКлиента
	|ГДЕ
	|	СчетчикДляОткрытияФормыОценкиМобильногоКлиента.ИдентификаторПриложения = &ИдентификаторПриложения";
	
	Запрос.УстановитьПараметр("ИдентификаторПриложения", ИдентификаторПриложения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоЗапусков;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьИдентификаторПриложения()
	
	СисИнфо = Новый СистемнаяИнформация;
	Возврат СисИнфо.ИдентификаторКлиента;
	
КонецФункции

#КонецОбласти

#КонецЕсли
