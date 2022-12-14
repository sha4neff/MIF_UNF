#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ИспользоватьСравнение = Истина;
	НастройкиОтчета.ПоказыватьНастройкиДиаграммыНаФормеОтчета = Ложь;
	НастройкиОтчета.ПоказыватьГруппуКолонкиНаФормеОтчета = Ложь;
	НастройкиОтчета.ДополнительныеГруппировкиСтрок.Добавить("СрокПополнения");
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	НастройкиВариантов["ОстаткиНоменклатурыПоставщиковДляОбменаССайтомКонтекст"].Теги = НСТР("ru = 'Обмен с сайтом,Товары,Запасы,Закупки'");
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
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияКоличества(ВариантыОформления, "Остаток");
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	СтруктураВарианта = НастройкиВариантов["ОстаткиНоменклатурыПоставщиковДляОбменаССайтомКонтекст"];
	ОтчетыУНФ.ДобавитьОписаниеПривязки(
		СтруктураВарианта.СвязанныеПоля,
		"НастройкаВыгрузкиОстатковНаСайт",
		"Справочник.НастройкиВыгрузкиОстатковПоставщиковНаСайт",
		,
		,
		Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли