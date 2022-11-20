#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ШтрихкодыУпаковокТоваров") Тогда
		
		ТабличныйДокумент = СформироватьПечатнуюФормуШтрихкодыУпаковки(ПараметрыПечати, ОбъектыПечати);
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ШтрихкодыУпаковокТоваров",
			НСтр("ru = 'Штрихкодов упаковок'"),
			ТабличныйДокумент);
			
	КонецЕсли;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуШтрихкодыУпаковки(ДанныеПечати, ОбъектыПечати)
	
	СвойстваОбъектовПечати = ПолучитьИзВременногоХранилища(ДАнныеПечати.АдресВХранилище);
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ШтрихкодыУпаковокТоваров_ШтрихкодыУпаковок";
	
	ПараметрыМакетов = Справочники.ШтрихкодыУпаковокТоваров.ПараметрыМакетовДляПечати();
	
	Для Каждого СвойстваОбъектаПечати Из СвойстваОбъектовПечати Цикл
		
		ПараметрыШтрихкодовУпаковок = Справочники.ШтрихкодыУпаковокТоваров.ПараметрыШтрихкодовУпаковокДляПечати();
		ЗаполнитьЗначенияСвойств(ПараметрыШтрихкодовУпаковок, СвойстваОбъектаПечати);
		
		Справочники.ШтрихкодыУпаковокТоваров.ДобавитьШтрихкодВТабличныйДокумент(
			ТабличныйДокумент,
			ПараметрыМакетов,
			ПараметрыШтрихкодовУпаковок);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ПриОпределенииКомандПодключенныхКОбъекту(Команды) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли