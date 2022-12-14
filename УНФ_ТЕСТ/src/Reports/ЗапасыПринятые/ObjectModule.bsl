#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПоказыватьНастройкиДиаграммыНаФормеОтчета = Ложь;
	
	НастройкиВариантов["Остатки"].Вставить("ТолькоРесурсыОстатков", Истина);
	
	НастройкиВариантов["ЗапасыВПереработке"].Рекомендуемый = Истина;
	
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
	МассивПолейСумм = Новый Массив;
	Для каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если НЕ ДоступноеПоле.Ресурс Тогда
			Продолжить;
		КонецЕсли;
		ИмяПоля = Строка(ДоступноеПоле.Поле);
		Если Найти(ИмяПоля, "Сумма")>0 Тогда
			МассивПолейСумм.Добавить(ИмяПоля);
		ИначеЕсли Найти(ИмяПоля, "Количество")>0 Тогда
			МассивПолейКоличеств.Добавить(ИмяПоля);
		КонецЕсли; 
	КонецЦикла;
	МассивПолейСумм.Добавить("СтоимостьЕд");
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияКоличества(ВариантыОформления, МассивПолейКоличеств);
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(ВариантыОформления, МассивПолейСумм);
			
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Ведомость"].Теги = НСтр("ru = 'Запасы,Закупки,Номенклатура,Комиссия'");
	НастройкиВариантов["Остатки"].Теги = НСтр("ru = 'Запасы,Закупки,Номенклатура,Комиссия'");
	НастройкиВариантов["ЗапасыВПереработке"].Теги = НСтр("ru = 'Запасы,Закупки,Номенклатура,Переработка,Производство'");
	НастройкиВариантов["ЗапасыНаОтветхранении"].Теги = НСтр("ru = 'Запасы,Закупки,Номенклатура,Ответхранение'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Ведомость"].СвязанныеПоля, "Контрагент", "Справочник.Контрагенты");
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Ведомость"].СвязанныеПоля, "Контрагент", "Документ.ОтчетКомитенту",,, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Остатки"].СвязанныеПоля, "Контрагент", "Документ.ОтчетКомитенту",,, Истина);
	
КонецПроцедуры
 
#КонецОбласти 

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли