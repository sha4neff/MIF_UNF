
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбластьДействияЧисло=?(ЗначениеЗаполнено(Запись.ТолькоДляВидаПроцесса), 1, 0);
	
	УстановитьОтображениеЭлементов();	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменаНеАктуальнаПриИзменении(Элемент)
	Если Запись.ЗаменаНеАктуальна И НЕ ЗначениеЗаполнено(Запись.ДатаОкончания) Тогда
		Запись.ДатаОкончания=ТекущаяДата();
		
	КонецЕсли;
	
	УстановитьОтображениеЭлементов();
	
КонецПроцедуры

Процедура УстановитьОтображениеЭлементов()
	Элементы.Период.Доступность=НЕ Запись.ЗаменаНеАктуальна;
	Элементы.ДатаОкончания.Доступность=НЕ Запись.ЗаменаНеАктуальна;
	УстановитьОформлениеОбластиДействия();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбластьДействияЧислоПриИзменении(Элемент)
	
	Модифицированность=Истина;
	
	УстановитьОформлениеОбластиДействия();
	
	Если ОбластьДействияЧисло=0 Тогда
		Запись.ТолькоДляВидаПроцесса=Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьОформлениеОбластиДействия()
	Элементы.ТолькоДляВидаПроцесса.Видимость=(ОбластьДействияЧисло=1);
	
КонецПроцедуры
