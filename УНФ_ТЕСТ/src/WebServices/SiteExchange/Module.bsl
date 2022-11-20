
#Область ПрограммныйИнтерфейс

Функция GetItems(ModificationDate, GroupCode) Экспорт
	
	Попытка

	Возврат ОбменССайтомВебСервер.ПолучитьКлассификаторИКаталог(ModificationDate, GroupCode);
	
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange.GetItems'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		ВызватьИсключение ПредставлениеОшибки;
		
	КонецПопытки;
	
КонецФункции

Функция GetAmountAndPrices(ModificationDate, GroupCode, WarehouseCode, OrganizationCode) Экспорт
	
	Попытка

		Возврат ОбменССайтомВебСервер.ПолучитьОстаткиИЦены(ModificationDate, GroupCode, WarehouseCode, OrganizationCode);
		
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange.GetAmountAndPrices'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		ВызватьИсключение ПредставлениеОшибки;
		
	КонецПопытки;
	
КонецФункции

Функция GetOrders(ModificationDate) Экспорт
	
	Попытка

		Возврат ОбменССайтомВебСервер.ПолучитьЗаказы(ModificationDate);
	
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange.GetOrders'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		ВызватьИсключение ПредставлениеОшибки;
		
	КонецПопытки;
	
КонецФункции

Функция LoadOrders(OrdersData) Экспорт
	
	Попытка

		Возврат ОбменССайтомВебСервер.ЗагрузитьЗаказы(OrdersData);
	
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange.LoadOrders'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		ВызватьИсключение ПредставлениеОшибки;
		
	КонецПопытки;	
	
КонецФункции

Функция GetPicture(ItemID) Экспорт
	
	Попытка

		Возврат ОбменССайтомВебСервер.ПолучитьКартинку(ItemID);
	
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange.GetPicture'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		ВызватьИсключение ПредставлениеОшибки;
		
	КонецПопытки;	
	
КонецФункции

#КонецОбласти
