
#Область ПрограммныйИнтерфейс

Функция GetItems(ModificationDate, GroupCode, SettingsExchangeCode = Неопределено) Экспорт
	
	Попытка

		Возврат ОбменССайтомВебСервер.ПолучитьКлассификаторИКаталог(ModificationDate, GroupCode, SettingsExchangeCode);
	
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange2.GetItems'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		ВызватьИсключение ПредставлениеОшибки;
		
	КонецПопытки;
	
КонецФункции

Функция GetAmountAndPrices(ModificationDate, GroupCode, WarehouseCode, OrganizationCode, SettingsExchangeCode = Неопределено) Экспорт
	
	Попытка

		Возврат ОбменССайтомВебСервер.ПолучитьОстаткиИЦены(ModificationDate, GroupCode, WarehouseCode, OrganizationCode, SettingsExchangeCode);
	
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange2.GetAmountAndPrices'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		ВызватьИсключение ПредставлениеОшибки;
		
	КонецПопытки;
	
КонецФункции

Функция GetOrders(ModificationDate, SettingsExchangeCode = Неопределено) Экспорт
	
	Попытка

		Возврат ОбменССайтомВебСервер.ПолучитьЗаказы(ModificationDate, SettingsExchangeCode);
	
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange2.GetOrders'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		ВызватьИсключение ПредставлениеОшибки;
		
	КонецПопытки;
	
КонецФункции

Функция LoadOrders(OrdersData, SettingsExchangeCode = Неопределено) Экспорт
	
	Попытка

		Возврат ОбменССайтомВебСервер.ЗагрузитьЗаказы(OrdersData, SettingsExchangeCode);
	
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange2.LoadOrders'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		ВызватьИсключение ПредставлениеОшибки;
		
	КонецПопытки;	
	
КонецФункции

Функция GetPicture(ItemID, SettingsExchangeCode = Неопределено) Экспорт
	
	Попытка

		Возврат ОбменССайтомВебСервер.ПолучитьКартинку(ItemID);
	
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange2.GetPicture'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		ВызватьИсключение ПредставлениеОшибки;
		
	КонецПопытки;	
	
КонецФункции

#КонецОбласти