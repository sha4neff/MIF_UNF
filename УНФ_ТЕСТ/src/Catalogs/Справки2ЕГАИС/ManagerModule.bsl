#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Ключ")
		И Параметры.Ключ = Справочники.Справки2ЕГАИС.ДляОприходованияИзлишков Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ПредопределенныйЭлемент";
		
	Иначе
		
		ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыСправочника(
			"Справки2ЕГАИС",
			ВидФормы,
			Параметры,
			ВыбраннаяФорма,
			ДополнительнаяИнформация,
			СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
