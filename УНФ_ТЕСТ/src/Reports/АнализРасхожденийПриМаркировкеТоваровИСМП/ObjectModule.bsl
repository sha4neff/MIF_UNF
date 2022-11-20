#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыИС.ИнициализироватьСхемуКомпоновки(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = Форма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
		И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "АнализРасхожденийПриМаркировкеТоваровИСМП" Тогда
			
			ТипОснования = Метаданные.ОпределяемыеТипы.ОснованиеМаркировкаТоваровИСМП.Тип;
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	ДокументИСМП.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.МаркировкаТоваровИСМП КАК ДокументИСМП
				|ГДЕ
				|	ДокументИСМП.Ссылка В(&МассивСсылок)
				|И
				|	НЕ ДокументИСМП.ДокументОснование В (&ПустыеОснования)";
			
			Запрос.УстановитьПараметр("МассивСсылок", Параметры.ПараметрКоманды);
			Запрос.УстановитьПараметр("ПустыеОснования", ИнтеграцияИС.МассивПустыхЗначенийСоставногоТипа(ТипОснования));
			
			МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДокументОснование");
			
			Форма.ФормаПараметры.Отбор.Вставить("ДокументОснование", МассивСсылок);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОтчетыИС.ИнициализироватьСхемуКомпоновки(ЭтотОбъект, Форма);
	
КонецПроцедуры

//Часть запроса отвечающего за данные прикладных документов
//
//Возвращаемое значение:
//   Строка - переопределяемая часть отчета о расхождениях
//
Функция ПереопределяемаяЧасть() Экспорт
	
	Возврат ОтчетыИС.ШаблонПолученияДанныхПрикладныхДокументов() + ИнтеграцияИСМП.ШаблонПолученияВидаПродукцииИзНоменклатуры();
	
КонецФункции

#КонецОбласти

#КонецЕсли