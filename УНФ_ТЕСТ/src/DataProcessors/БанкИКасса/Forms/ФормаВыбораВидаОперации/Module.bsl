#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДеревоЗначений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоЗначений

&НаКлиенте
Процедура ДеревоЗначенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтрокаДляПоиска = "Из кассы на счет, Со счета в кассу, Между счетами, Между кассами";
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(Элементы.ДеревоЗначений.ТекущиеДанные.ВидОперации) = Тип("Строка") И СтрНайти(СтрокаДляПоиска,
		Элементы.ДеревоЗначений.ТекущиеДанные.ВидОперации) = 0 Тогда
		ПоказатьПредупреждение(Неопределено, "Выберите операцию (не группу)");
	Иначе
		Закрыть(Элемент.ТекущиеДанные.ВидОперации);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ТипЗнч(Элементы.ДеревоЗначений.ТекущиеДанные.ВидОперации) = Тип("СправочникСсылка.ХозяйственныеОперации") Тогда
		Закрыть(Элементы.ДеревоЗначений.ТекущиеДанные.ВидОперации);
	Иначе
		ПоказатьПредупреждение(Неопределено, "Выберите операцию (не группу)");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПеренестиСписокВДерево(СписокХозОпераций, ВеткаРодитель)
	
	Для Каждого ЭлементСписка Из СписокХозОпераций Цикл
		ДобавитьЗначениеВДерево(ЭлементСписка, ВеткаРодитель);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗначениеВДерево(ЭлементСписка, ВеткаРодитель)
	
	СтрокаДерева = ВеткаРодитель.ПолучитьЭлементы().Добавить();
	СтрокаДерева.ВидОперации = ЭлементСписка.Значение;
	СтрокаДерева.ВидОперацииПредставление = ?(ЗначениеЗаполнено(ЭлементСписка.Представление),
		ЭлементСписка.Представление, ЭлементСписка.Значение);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоЗначений()
	
	// Поступление.
	ВеткаПоступление = ДеревоЗначений.ПолучитьЭлементы().Добавить();
	ВеткаПоступление.ВидОперации = "Поступление";
	ВеткаПоступление.ВидОперацииПредставление = "Поступление";
	
	СписокВидовОпераций = ДвиженияДенежныхСредствВызовСервера.ПолучитьСписокХозОперацийПоступленияДС();
	ПеренестиСписокВДерево(СписокВидовОпераций, ВеткаПоступление);
	
	// Расход.
	ВеткаРасход = ДеревоЗначений.ПолучитьЭлементы().Добавить();
	ВеткаРасход.ВидОперации = "Расход";
	ВеткаРасход.ВидОперацииПредставление = "Расход";
	
	СписокХозОпераций = ДвиженияДенежныхСредствВызовСервера.ПолучитьСписокХозОперацийРасходДС();
	ПеренестиСписокВДерево(СписокХозОпераций, ВеткаРасход);
	
	// Перемещение.
	ВеткаПеремещение = ДеревоЗначений.ПолучитьЭлементы().Добавить();
	ВеткаПеремещение.ВидОперации = Справочники.ХозяйственныеОперации.ПеремещениеДС;
	ВеткаПеремещение.ВидОперацииПредставление = Справочники.ХозяйственныеОперации.ПеремещениеДС;
	
	ВеткаРодитель = ВеткаПеремещение.ПолучитьЭлементы().Добавить();
	ВеткаРодитель.ВидОперации = "Из кассы на счет";
	ВеткаРодитель.ВидОперацииПредставление = "Из кассы на счет";
	
	ВеткаРодитель = ВеткаПеремещение.ПолучитьЭлементы().Добавить();
	ВеткаРодитель.ВидОперации = "Со счета в кассу";
	ВеткаРодитель.ВидОперацииПредставление = "Со счета в кассу";
	
	ВеткаРодитель = ВеткаПеремещение.ПолучитьЭлементы().Добавить();
	ВеткаРодитель.ВидОперации = "Между счетами";
	ВеткаРодитель.ВидОперацииПредставление = "Между счетами";
	
	ВеткаРодитель = ВеткаПеремещение.ПолучитьЭлементы().Добавить();
	ВеткаРодитель.ВидОперации = "Между кассами";
	ВеткаРодитель.ВидОперацииПредставление = "Между кассами";
	
КонецПроцедуры

#КонецОбласти
