#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.Вставить("ФиксироватьКолонки", Истина);
	НастройкиВариантов["Основной"].Рекомендуемый = Истина;
	
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
	
	МассивПолейКоличеств = Новый Массив;
	Для каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если НЕ ДоступноеПоле.Ресурс Тогда
			Продолжить;
		КонецЕсли;
		ИмяПоля = Строка(ДоступноеПоле.Поле);
		МассивПолейКоличеств.Добавить(ИмяПоля);
	КонецЦикла; 
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияКоличества(ВариантыОформления, МассивПолейКоличеств);
			
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСтр("ru = 'Запасы,Закупки,Заказы,Отгрузки,Поступления'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Основной"].СвязанныеПоля, "Заказ", "Документ.ЗаказПокупателя");
	
КонецПроцедуры
 
#КонецОбласти 

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли