#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ЭтоНовый() Тогда
		
		Если НЕ ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
			Организации.Очистить();
		ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
			ИспользоватьОтборПоОрганизациям = Ложь;
		КонецЕсли;
		
		Если НЕ ИспользоватьОтборПоВидамДокументов И ВидыДокументов.Количество() <> 0 Тогда
			ВидыДокументов.Очистить();
		ИначеЕсли ВидыДокументов.Количество() = 0 И ИспользоватьОтборПоВидамДокументов Тогда
			ИспользоватьОтборПоВидамДокументов = Ложь;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(РежимВыгрузкиПриНеобходимости) Тогда
			РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		КонецЕсли;
		
		Если РучнойОбмен Тогда
			РежимСинхронизацииДанных = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
		Иначе
			РежимСинхронизацииДанных = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВсегда;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
	// настройка отборов
	ДатаНачалаВыгрузкиДокументов = НачалоГода(ТекущаяДата());
	ИспользоватьОтборПоОрганизациям = Ложь;
	ИспользоватьОтборПоВидамДокументов = Ложь;
	РучнойОбмен = Ложь;
	ОбобщенныйСклад = Справочники.СтруктурныеЕдиницы.ОсновнойСклад;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли