#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПоказыватьГруппуСтрокиНаФормеОтчета = Ложь;
	НастройкиОтчета.ПоказыватьНастройкиДиаграммыНаФормеОтчета = Ложь;
	
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
	Для каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если НЕ ДоступноеПоле.Ресурс Тогда
			Продолжить;
		КонецЕсли;
		ИмяПоля = Строка(ДоступноеПоле.Поле);
		МассивПолейСумм.Добавить(ИмяПоля);
	КонецЦикла; 
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(ВариантыОформления, МассивПолейСумм);
			
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСТР("ru = 'Деньги'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Основной"].СвязанныеПоля, "БанковскийСчетКасса", "Справочник.Кассы");
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Основной"].СвязанныеПоля, "БанковскийСчетКасса", "Справочник.БанковскиеСчета");
	
КонецПроцедуры
 
#КонецОбласти 

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли