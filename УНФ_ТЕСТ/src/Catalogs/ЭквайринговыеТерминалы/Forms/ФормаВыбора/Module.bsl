#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
		Элементы.Эквайрер.Видимость = Ложь;
		Элементы.Договор.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
