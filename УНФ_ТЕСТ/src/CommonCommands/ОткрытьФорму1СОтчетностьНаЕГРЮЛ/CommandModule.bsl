

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.ЕГРЮЛ"));
	
	ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность", ПараметрыОткрытия, ПараметрыВыполненияКоманды.Источник, "1С-Отчетность", ПараметрыВыполненияКоманды.Окно);
	
	Оповестить("Открытие формы 1С-Отчетность", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти