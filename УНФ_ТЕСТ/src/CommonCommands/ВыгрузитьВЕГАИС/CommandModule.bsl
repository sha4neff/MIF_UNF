
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	СоответствиеДокументов = Новый Соответствие;
	СоответствиеДокументов.Вставить(Тип("ДокументСсылка.ОтчетОРозничныхПродажах"),  "Документ.АктСписанияЕГАИС");
	СоответствиеДокументов.Вставить(Тип("ДокументСсылка.СписаниеЗапасов"),          "Документ.АктСписанияЕГАИС");
	СоответствиеДокументов.Вставить(Тип("ДокументСсылка.ОприходованиеЗапасов"),     "Документ.АктПостановкиНаБалансЕГАИС");
	СоответствиеДокументов.Вставить(Тип("ДокументСсылка.ПеремещениеЗапасов"),       "Документ.ТТНИсходящаяЕГАИС");
	СоответствиеДокументов.Вставить(Тип("ДокументСсылка.РасходнаяНакладная"),       "Документ.ТТНИсходящаяЕГАИС");
	СоответствиеДокументов.Вставить(Тип("ДокументСсылка.ПриходнаяНакладная"),       "Документ.ТТНИсходящаяЕГАИС");
	
	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.РасходнаяНакладная") Тогда
		СтруктураРеквизитов = ДанныеДокумента(ПараметрКоманды, "ВидОперации");
		Если СтруктураРеквизитов.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходнаяНакладная.ПродажаПокупателю") Тогда
			СоответствиеДокументов.Вставить(Тип("ДокументСсылка.РасходнаяНакладная"), "Документ.ЧекЕГАИС");
		КонецЕсли;
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ПриходнаяНакладная") Тогда
		СтруктураРеквизитов = ДанныеДокумента(ПараметрКоманды, "ВидОперации");
		Если СтруктураРеквизитов.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя") Тогда
			СоответствиеДокументов.Вставить(Тип("ДокументСсылка.ПриходнаяНакладная"), "Документ.ЧекЕГАИСВозврат");
		КонецЕсли;
	КонецЕсли;
	
	ИмяДокумента = СоответствиеДокументов[ТипЗнч(ПараметрКоманды)];
	Если ИмяДокумента <> Неопределено Тогда
		
		ДокументЕГАИС = ИнтеграцияЕГАИСУНФВызовСервера.ДокументаЕГАИСПоОснованию(ПараметрКоманды, ИмяДокумента);
		Если ЗначениеЗаполнено(ДокументЕГАИС) Тогда
			ДополнительныеПараметры = Новый Структура("Ключ", ДокументЕГАИС);
		Иначе
			ДополнительныеПараметры = Новый Структура("Основание", ПараметрКоманды);
		КонецЕсли;
		
		ОткрытьФорму(ИмяДокумента+".ФормаОбъекта", ДополнительныеПараметры);
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДанныеДокумента(ПараметрКоманды, Знач Реквизиты)
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрКоманды, Реквизиты);
	Возврат СтруктураРеквизитов;
	
КонецФункции

#КонецОбласти
