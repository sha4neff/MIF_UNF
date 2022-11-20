#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура УвеличитьСчетчик(ЭтоМобильныйКлиент) Экспорт
	
	Если РаботаВМоделиСервиса.РазделениеВключено()
		И РаботаВМоделиСервиса.СеансЗапущенБезРазделителей() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗначениеСчетчика = ПолучитьЗначенияСчетчика();
	ИдентификаторКлиента = ПолучитьИдентификаторКлиента();
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИдентификаторКлиента = ИдентификаторКлиента;
	МенеджерЗаписи.КоличествоЗапусков = ?(ЗначениеСчетчика = 0, 1, ЗначениеСчетчика.КоличествоЗапусков + 1);
	МенеджерЗаписи.ДатаПоследнегоЗапуска = ТекущаяДатаСеанса();
	МенеджерЗаписи.ЭтоМобильныйКлиент = ЭтоМобильныйКлиент;
	
	Если ЗначениеСчетчика = 0 Тогда
		МенеджерЗаписи.ДатаПервогоЗапуска = ТекущаяДатаСеанса();
	Иначе
		МенеджерЗаписи.ЭтоАктивный = ?(МенеджерЗаписи.ДатаПоследнегоЗапуска - ЗначениеСчетчика.ДатаПоследнегоЗапуска <= 60 * 60 * 24 * 30, Истина, Ложь);
		МенеджерЗаписи.ЗапретОткрытияОпроса = ЗначениеСчетчика.ЗапретОткрытияОпроса;
		МенеджерЗаписи.ДатаПервогоЗапуска = ЗначениеСчетчика.ДатаПервогоЗапуска;
	КонецЕсли;
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

Функция ПолучитьЗначенияСчетчика() Экспорт
	
	Если РаботаВМоделиСервиса.РазделениеВключено()
		И РаботаВМоделиСервиса.СеансЗапущенБезРазделителей() Тогда
		Возврат 0;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторКлиента = ПолучитьИдентификаторКлиента();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СчетчикЗапусковКлиента.ИдентификаторКлиента КАК ИдентификаторКлиента,
	|	СчетчикЗапусковКлиента.ДатаПоследнегоЗапуска КАК ДатаПоследнегоЗапуска,
	|	СчетчикЗапусковКлиента.КоличествоЗапусков КАК КоличествоЗапусков,
	|	СчетчикЗапусковКлиента.ЭтоАктивный КАК ЭтоАктивный,
	|	СчетчикЗапусковКлиента.ЭтоМобильныйКлиент КАК ЭтоМобильныйКлиент,
	|	СчетчикЗапусковКлиента.ЗапретОткрытияОпроса КАК ЗапретОткрытияОпроса,
	|	СчетчикЗапусковКлиента.ДатаПервогоЗапуска КАК ДатаПервогоЗапуска,
	|	СчетчикЗапусковКлиента.ЗапретОткрытияФормыПереходаВМК КАК ЗапретОткрытияФормыПереходаВМК
	|ИЗ
	|	РегистрСведений.СчетчикЗапусковКлиента КАК СчетчикЗапусковКлиента
	|ГДЕ
	|	СчетчикЗапусковКлиента.ИдентификаторКлиента = &ИдентификаторКлиента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетчикЗапусковКлиента.ИдентификаторКлиента КАК ИдентификаторКлиента
	|ИЗ
	|	РегистрСведений.СчетчикЗапусковКлиента КАК СчетчикЗапусковКлиента
	|ГДЕ
	|	СчетчикЗапусковКлиента.ЭтоМобильныйКлиент = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("ИдентификаторКлиента", ИдентификаторКлиента);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Если РезультатЗапроса[0].Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	Выборка = РезультатЗапроса[0].Выбрать();
	ВыборкаТолькоМобильныеКлиенты = РезультатЗапроса[1].Выбрать();
	
	Выборка.Следующий();
	ТолькоМобильныеКлиенты = НЕ ВыборкаТолькоМобильныеКлиенты.Следующий();
	
	СтруктураВозврата = Новый Структура("ИдентификаторКлиента, ДатаПоследнегоЗапуска, КоличествоЗапусков, ЭтоАктивный, ЭтоМобильныйКлиент, ЗапретОткрытияОпроса, ДатаПервогоЗапуска, ТолькоМобильныеКлиенты, ЗапретОткрытияФормыПереходаВМК, ЭтоМобильныйБраузер");
	ЗаполнитьЗначенияСвойств(СтруктураВозврата, Выборка);
	СтруктураВозврата.ТолькоМобильныеКлиенты = ТолькоМобильныеКлиенты;
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИнформацияПрограммыПросмотра = НРег(СистемнаяИнформация.ИнформацияПрограммыПросмотра);
	
	Если СтрНайти(ИнформацияПрограммыПросмотра, "iphone") <> 0
		ИЛИ СтрНайти(ИнформацияПрограммыПросмотра, "ipod") <> 0 
		ИЛИ СтрНайти(ИнформацияПрограммыПросмотра, "android") <> 0 Тогда
		СтруктураВозврата.ЭтоМобильныйБраузер = Истина;
	Иначе
		СтруктураВозврата.ЭтоМобильныйБраузер = Ложь;
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Процедура УстановитьЗапретОткрытияФормыОпроса(ЗапретОткрытияОпроса) Экспорт
	
	Если РаботаВМоделиСервиса.СеансЗапущенБезРазделителей() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗначениеСчетчика = ПолучитьЗначенияСчетчика();
	Если ЗначениеСчетчика = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ЗначениеСчетчика);
	МенеджерЗаписи.ЗапретОткрытияОпроса = ЗапретОткрытияОпроса;
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьИдентификаторКлиента()
	
	СисИнфо = Новый СистемнаяИнформация;
	Возврат СисИнфо.ИдентификаторКлиента;
	
КонецФункции

#КонецОбласти

#КонецЕсли
