#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура("Ссылка", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.Обсуждения.Форма.ФормаОбсуждения", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"Обсуждения", ПараметрыВыполненияКоманды.Источник);

КонецПроцедуры

#КонецОбласти
