
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	СвойМакетОформления=ПолучитьОбщийМакет("КП_МакетОформленияОтчетов");
	
	КомпоновщикМакета=Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки=КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки, ДанныеРасшифровки, СвойМакетОформления);
	
	ПроцессорКомпоновки=Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода=Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры
