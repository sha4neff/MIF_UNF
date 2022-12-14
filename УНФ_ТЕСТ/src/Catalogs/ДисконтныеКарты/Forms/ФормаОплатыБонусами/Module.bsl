#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("БонуснаяКарта") Тогда
		БонуснаяКарта = Параметры.БонуснаяКарта;
	КонецЕсли;
	
	Если Параметры.Свойство("Документ") Тогда
		Документ = Параметры.Документ;
		СуммаДокумента = Документ.СуммаДокумента + Документ.Запасы.Итог("СуммаСкидкиОплатыБонусом");
		Если Не ЗначениеЗаполнено(БонуснаяКарта) Тогда
			БонуснаяКарта = Документ.ДисконтнаяКарта;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("КОплате") Тогда
		КОплате = Параметры.КОплате;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СуммаБонусов") Тогда
		СуммаОплаты = Параметры.СуммаБонусов;
	КонецЕсли;
	
	Если Не Документ = Неопределено Тогда
		
		// Получим максимальный процент оплаты
		ОграничениеОплаты = РаботаСБонусами.ОпределитьОграничениеОплаты(Документ.ДисконтнаяКарта, СуммаДокумента);
		
		// Получим остаток и владельца
		СтруктураДанных = РаботаСБонусами.ПолучитьДанныеБонуснойКарты(Документ.ДисконтнаяКарта, Документ.Дата);
		Остаток = СтруктураДанных.Остаток;
		СтруктураОстатка.Загрузить(СтруктураДанных.ТаблицаДвижений);
		Владелец = СтруктураДанных.Владелец;
		
	КонецЕсли;
	
	МинимальнаяСумма = Мин(Остаток, КОплате, ОграничениеОплаты);
	
	Если Остаток = МинимальнаяСумма Тогда
		Элементы.СуммаОплаты.СписокВыбора.Добавить(Остаток, "" + Остаток + " (Остаток)");
	ИначеЕсли КОплате = МинимальнаяСумма Тогда
		Элементы.СуммаОплаты.СписокВыбора.Добавить(КОплате, "" + КОплате + " (К оплате)");
	ИначеЕсли ОграничениеОплаты = МинимальнаяСумма Тогда
		Элементы.СуммаОплаты.СписокВыбора.Добавить(ОграничениеОплаты, "" + ОграничениеОплаты + " (Макс.)");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если СуммаОплаты > Остаток Тогда
		ТекстСообщения = НСтр("ru = 'Превышен остаток баллов по карте!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "СуммаОплаты", "СуммаОплаты");
		Возврат;
	КонецЕсли;
	
	Если СуммаОплаты > КОплате Тогда
		ТекстСообщения = НСтр("ru = 'Сумма оплаты не может превышать сумму документа!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "СуммаОплаты", "СуммаОплаты");
		Возврат;
	КонецЕсли;
	
	Если СуммаОплаты > ОграничениеОплаты Тогда
		ТекстСообщения = НСтр("ru = 'Сумма оплаты не может превышать ограничение, установленное для бонусной программы!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "СуммаОплаты", "СуммаОплаты");
		Возврат;
	КонецЕсли;
	
	Если СуммаОплаты = 0 Тогда
		ПараметрыЗакрытия = Неопределено;
	Иначе
		ПараметрыЗакрытия = Новый Структура("БонуснаяКарта, СуммаБонусов, ВидОплаты, ЕстьОплатаБонусами",
			БонуснаяКарта,
			СуммаОплаты,
			ПредопределенноеЗначение("Перечисление.ВидыБезналичныхОплат.Бонусы"),
			Истина);
	КонецЕсли;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти
