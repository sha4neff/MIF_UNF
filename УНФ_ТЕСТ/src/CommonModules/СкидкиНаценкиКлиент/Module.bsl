
#Область ПрограммныйИнтерфейс

// Процедура открывает форму расшифровки скидок рассчитанных по текущей строке табличной части
//
// Параметры
//  ТекущиеДанные  - СтрокаТабличнойЧасти - строка для которой необходимо открыть расшифровку скидок
//  Объект  - ДанныеФормы - Объект, для которого нужно открыть форму расшифровки скидок
//  Форма  - Форма - Форма объекта
//
Процедура ОткрытьФормуПримененныеСкидки(ТекущиеДанные, Объект, Форма) Экспорт
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтрокиТабличнойЧасти = Новый Структура;
	Если ЗаказНарядИмеетДвеТабличныеЧасти(ТекущиеДанные) Тогда
		ДанныеСтрокиТабличнойЧасти.Вставить("КлючСвязи", ТекущиеДанные.КлючСвязиДляСкидокНаценок);
	Иначе
		ДанныеСтрокиТабличнойЧасти.Вставить("КлючСвязи", ТекущиеДанные.КлючСвязи);
	КонецЕсли;
	ДанныеСтрокиТабличнойЧасти.Вставить("Номенклатура", ТекущиеДанные.Номенклатура);
	ДанныеСтрокиТабличнойЧасти.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	ДанныеСтрокиТабличнойЧасти.Вставить("СуммаРучнойСкидки",
		ТекущиеДанные.Цена * ТекущиеДанные.Количество * ТекущиеДанные.ПроцентСкидкиНаценки / 100);
	ДанныеСтрокиТабличнойЧасти.Вставить("СуммаБезСкидки", ТекущиеДанные.Цена * ТекущиеДанные.Количество);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Объект", Объект);
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Примененные скидки (наценки) для строки'"));
	ПараметрыФормы.Вставить("ТекущиеДанные", ДанныеСтрокиТабличнойЧасти);
	ПараметрыФормы.Вставить("АдресПримененныхСкидокВоВременномХранилище",
		Форма.АдресПримененныхСкидокВоВременномХранилище);
	ПараметрыФормы.Вставить("ОтображатьИнформациюОСкидкахПоСтроке", Истина);
	ПараметрыФормы.Вставить("ОтображатьИнформациюОРасчетеСкидокПоСтроке", Истина);
	ПараметрыФормы.Вставить("ОтображатьИнформациюОРасчетеСкидокПоДокументуВЦелом", Ложь);
	ПараметрыФормы.Вставить("ОтображатьИсключение", Истина);
	
	ОткрытьФорму("ОбщаяФорма.ПримененныеСкидкиНаценки", ПараметрыФормы, Форма, Форма.УникальныйИдентификатор);
	
КонецПроцедуры

// Выводит сообщение о расчете скидок когда нажата кнопка "Провести и закрыть" или форма закрывается по крестику
// с сохранением изменений.
//
// Параметры:
//  ОбъектСсылка					 - ДокументСсылка - ссылка на объект.
//  ИспользоватьАвтоматическиеСкидки - Булево - .
//  СкидкиРассчитаныПередЗаписью	 - Булево - .
//
Процедура ПриЗакрытииФормы(ОбъектСсылка, ИспользоватьАвтоматическиеСкидки, СкидкиРассчитаныПередЗаписью) Экспорт
	
	Если ИспользоватьАвтоматическиеСкидки И СкидкиРассчитаныПередЗаписью Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Изменение:'"), ПолучитьНавигационнуюСсылку(ОбъектСсылка),
			СтрШаблон(НСтр("ru = '%1. Автоматические скидки (наценки) рассчитаны.'"), ОбъектСсылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаказНарядИмеетДвеТабличныеЧасти(ТекущиеДанные)
	
	Возврат ТекущиеДанные.Свойство("КлючСвязиДляСкидокНаценок");
	
КонецФункции

#КонецОбласти