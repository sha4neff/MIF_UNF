
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Параметры = Новый Структура;
	Параметры.Вставить("Ключ", ПолучитьСсылкуЭлемента());
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСсылкуЭлемента()
	
	Возврат Константы.КонтрагентДляПодарочныхСертификатов.Получить();
	
КонецФункции

#КонецОбласти