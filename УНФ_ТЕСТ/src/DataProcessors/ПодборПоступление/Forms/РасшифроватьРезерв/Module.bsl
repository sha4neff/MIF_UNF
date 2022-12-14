#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПараметрыДинамическихСписков();
	
	Номенклатура = Параметры.Номенклатура;
	Характеристика = Параметры.Характеристика;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()

	СписокРасшифровкаРезерва.Параметры.УстановитьЗначениеПараметра("Организация",
		УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Параметры.Организация));
	СписокРасшифровкаРезерва.Параметры.УстановитьЗначениеПараметра("Номенклатура", Параметры.Номенклатура);
	СписокРасшифровкаРезерва.Параметры.УстановитьЗначениеПараметра("Характеристика", Параметры.Характеристика);

КонецПроцедуры

#КонецОбласти
