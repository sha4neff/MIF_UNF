#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиВариантов["ВедомостьВВалюте"].Рекомендуемый = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	МассивПолейСумм = Новый Массив;
	Для Каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если Не ДоступноеПоле.Ресурс Тогда
			Продолжить;
		КонецЕсли;
		МассивПолейСумм.Добавить(Строка(ДоступноеПоле.Поле));
	КонецЦикла;
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(
		ВариантыОформления,
		МассивПолейСумм);
	КонецЦикла
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Ведомость"].Теги = НСтр("ru = 'Деньги,Запасы,Закупки,Контрагенты,Поставщики,Кредиторка'");
	НастройкиВариантов["Остатки"].Теги = НСтр("ru = 'Деньги,Запасы,Закупки,Контрагенты,Поставщики,Кредиторка'");
	НастройкиВариантов["ВедомостьВВалюте"].Теги = НСтр("ru = 'Деньги,Запасы,Закупки,Контрагенты,Поставщики,Кредиторка'");
	НастройкиВариантов["ОстаткиВВалюте"].Теги = НСтр("ru = 'Деньги,Запасы,Закупки,Контрагенты,Поставщики,Кредиторка'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "Контрагент", "Справочник.Контрагенты");
		ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиТекВарианта.Значение.СвязанныеПоля, "Заказ", "Документ.ЗаказПокупателя");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли