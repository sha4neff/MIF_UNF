
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	// Вставить содержимое обработчика.
	ОтборСтруктура = Новый Структура("Касса", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", ОтборСтруктура);
	ОткрытьФорму("Справочник.ЭквайринговыеТерминалы.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти
