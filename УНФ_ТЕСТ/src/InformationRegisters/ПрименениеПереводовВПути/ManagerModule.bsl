#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ИспользуютсяПереводыВПути(ДатаПроверки = Неопределено, Организация = Неопределено) Экспорт
	
	Если ДатаПроверки = Неопределено Тогда
		ДатаПроверки = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаСреза", ДатаПроверки);
	
	Если Организация = Неопределено Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкаОрганизацийСрезПоследних.Организация
		|ИЗ
		|	РегистрСведений.ПрименениеПереводовВПути.СрезПоследних(&ДатаСреза, ) КАК НастройкаОрганизацийСрезПоследних
		|ГДЕ
		|	НастройкаОрганизацийСрезПоследних.ИспользоватьПереводыВПутиПриПеремещенияДенежныхСредств";
	Иначе
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкаОрганизацийСрезПоследних.Организация
		|ИЗ
		|	РегистрСведений.ПрименениеПереводовВПути.СрезПоследних(&ДатаСреза, Организация = &Организация) КАК НастройкаОрганизацийСрезПоследних
		|ГДЕ
		|	НастройкаОрганизацийСрезПоследних.ИспользоватьПереводыВПутиПриПеремещенияДенежныхСредств";
		
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли
