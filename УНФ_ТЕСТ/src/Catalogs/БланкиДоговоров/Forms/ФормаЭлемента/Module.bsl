
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗначениеКопирования = Неопределено;
	Параметры.Свойство("ЗначениеКопирования", ЗначениеКопирования);
	
	Если ЗначениеЗаполнено(Объект.МакетПредопределенногоБланка) Тогда 
		Элементы.ВосстановитьПредопределенныйБланкПоУмолчанию.Видимость = Истина;
	Иначе 
		Элементы.ВосстановитьПредопределенныйБланкПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Объект.Ссылка.Бланк.Получить() <> Неопределено Тогда 
			ФорматированныйДокумент.УстановитьHTML(Объект.Ссылка.Бланк.Получить().ТекстHTML,
													Объект.Ссылка.Бланк.Получить().Вложения);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(ЗначениеКопирования.Ссылка) Тогда 
		Если ЗначениеКопирования.Ссылка.Бланк.Получить() <> Неопределено Тогда 
			ФорматированныйДокумент.УстановитьHTML(ЗначениеКопирования.Ссылка.Бланк.Получить().ТекстHTML,
													ЗначениеКопирования.Ссылка.Бланк.Получить().Вложения);
		КонецЕсли;
	Иначе 
		ФорматированныйДокумент = Новый ФорматированныйДокумент;
	КонецЕсли;
	
	ДополнительныеРеквизитыЗаказаПокупателя      = УправлениеСвойствами.СвойстваОбъекта(Документы.ЗаказПокупателя.ПустаяСсылка(), Истина, Ложь);
	ДополнительныеРеквизитыСчетаНаОплату         = УправлениеСвойствами.СвойстваОбъекта(Документы.СчетНаОплату.ПустаяСсылка(), Истина, Ложь);
	ДополнительныеРеквизитыДоговоровКонтрагентов = УправлениеСвойствами.СвойстваОбъекта(Справочники.ДоговорыКонтрагентов.ПустаяСсылка(), Истина, Ложь);
	ДополнительныеРеквизитыКонтрагента           = УправлениеСвойствами.СвойстваОбъекта(Справочники.Контрагенты.ПустаяСсылка(), Истина, Ложь);
	ДополнительныеРеквизитыОрганизации           = УправлениеСвойствами.СвойстваОбъекта(Справочники.Организации.ПустаяСсылка(), Истина, Ложь);
	
	ДобавитьВставкуДополнительныхРеквизитов(Элементы.ГруппаДополнительныеРеквизитыЗаказаПокупателя, ДополнительныеРеквизитыЗаказаПокупателя);
	ДобавитьВставкуДополнительныхРеквизитов(Элементы.ГруппаДополнительныеРеквизитыСчетаНаОплату, ДополнительныеРеквизитыСчетаНаОплату);
	ДобавитьВставкуДополнительныхРеквизитов(Элементы.ГруппаПараметрыДоговора, ДополнительныеРеквизитыДоговоровКонтрагентов);
	ДобавитьВставкуДополнительныхРеквизитов(Элементы.ГруппаПараметрыКонтрагента, ДополнительныеРеквизитыКонтрагента);
	ДобавитьВставкуДополнительныхРеквизитов(Элементы.ГруппаПараметрыОрганизации, ДополнительныеРеквизитыОрганизации);
	
	ЭтаФорма.ФорматированныйДокумент.ПолучитьHTML(ЭтаФорма.ТекстБланкаПриОткрытии, Новый Структура());
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекстHTML = "";
	Вложения = Новый Структура;
	ФорматированныйДокумент.ПолучитьHTML(ТекстHTML, Вложения);
	
	СтруктураФорматированногоДокумента = Новый Структура;
	СтруктураФорматированногоДокумента.Вставить("ТекстHTML", ТекстHTML);
	СтруктураФорматированногоДокумента.Вставить("Вложения", Вложения);
	ТекущийОбъект.Бланк = Новый ХранилищеЗначения(СтруктураФорматированногоДокумента);
	
	Итератор = 0;
	Пока Итератор < ТекущийОбъект.РедактируемыеПараметры.Количество() Цикл 
		
		Если СтрНайти(ТекстHTML, ТекущийОбъект.РедактируемыеПараметры[Итератор].Представление) <> 0 Тогда 
			Итератор = Итератор + 1;
			Продолжить;
		КонецЕсли;
		
		ТекущийОбъект.РедактируемыеПараметры.Удалить(ТекущийОбъект.РедактируемыеПараметры[Итератор]);
		
	КонецЦикла;
	
	Итератор = 0;
	Пока Итератор < ТекущийОбъект.ПараметрыИнфобазы.Количество() Цикл 
		
		Если СтрНайти(ТекстHTML, ТекущийОбъект.ПараметрыИнфобазы[Итератор].Представление) <> 0 Тогда 
			Итератор = Итератор + 1;
			Продолжить;
		КонецЕсли;
		
		ТекущийОбъект.ПараметрыИнфобазы.Удалить(ТекущийОбъект.ПараметрыИнфобазы[Итератор]);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ТекстБланка = "";
	ЭтаФорма.ФорматированныйДокумент.ПолучитьHTML(ТекстБланка, Новый Структура());
	Если ТекстБланка <> ЭтаФорма.ТекстБланкаПриОткрытии Тогда
		Оповестить("ИзменениеИЗаписьБланкаДоговораНаСервере", Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ФорматированныйДокументПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

&НаКлиенте
Процедура ВставитьАдресЭлектроннойПочтыКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.АдресЭлектроннойПочтыКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьАдресЭлектроннойПочтыОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.АдресЭлектроннойПочтыОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьБанкКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.БанкКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьБанкОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.БанкОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДатуДоговора(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.Дата"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаИменительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ДолжностьКонтактногоЛицаКонтрагента"), "именительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаРодительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ДолжностьКонтактногоЛицаКонтрагента"), "родительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаДательный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ДолжностьКонтактногоЛицаКонтрагента"), "дательный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаВинительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ДолжностьКонтактногоЛицаКонтрагента"), "винительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаТворительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ДолжностьКонтактногоЛицаКонтрагента"), "творительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаПредложный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ДолжностьКонтактногоЛицаКонтрагента"), "предложный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьИННКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ИННКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьИННОргнанизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ИННОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКонтактноеЛицоКонтрагентаИменительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагента"), "именительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКонтактноеЛицоКонтрагентаРодительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагента"), "родительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКонтактноеЛицоКонтрагентаДательный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагента"), "дательный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКонтактноеЛицоКонтрагентаВинительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагента"), "винительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКонтактноеЛицоКонтрагентаТворительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагента"), "творительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКонтактноеЛицоКонтрагентаПредложный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагента"), "предложный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКППКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КППКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКППОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КППОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьНазваниеОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.НазваниеОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьНазваниеОрганизацииКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.НазваниеОрганизацииКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьНомерДоговора(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.НомерДоговора"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОКТМООрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ОКТМООрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОКАТООрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ОКАТООрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОКПОКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ОКПОКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОКПООрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ОКПООрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьПочтовыйАдресКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ПочтовыйАдресКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьПочтовыйАдресОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ПочтовыйАдресОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРасчетныйСчетКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РасчетныйСчетКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРасчетныйСчетОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РасчетныйСчетОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСрокОплатыПокупателя(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.СрокОплатыПокупателя"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСрокОплатыПоставщику(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.СрокОплатыПоставщику"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьТелефонКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ТелефонКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьТелефонОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ТелефонОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьФаксКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ФаксКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьФаксОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ФаксОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьФактическийАдресКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ФактическийАдресКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьФактическийАдресОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ФактическийАдресОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьЮридическийАдресКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ЮридическийАдресКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьЮридическийАдресОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ЮридическийАдресОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСуммуДокумента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.СуммаДокумента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСуммуДокументаПрописью(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.СуммаДокументаПрописью"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииИменительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизации"), "именительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииРодительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизации"), "родительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииДательный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизации"), "дательный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииВинительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизации"), "винительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииТворительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизации"), "творительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииПредложный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизации"), "предложный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРедактируемыйПараметр(Команда)
	
	ВставитьПараметр("%Параметр%");
	
	Если ФорматированныйДокумент.НайтиТекст("%Параметр%") <> Неопределено Тогда 
		
		РедактируемыйПараметр = РедактируемыйПараметр();
		
		ЗакладкаНачала = ФорматированныйДокумент.НайтиТекст("%Параметр%").ЗакладкаНачала;
		ЗакладкаКонца = ФорматированныйДокумент.НайтиТекст("%Параметр%").ЗакладкаКонца;
		
		ПозицияНачала = ФорматированныйДокумент.ПолучитьПозициюПоЗакладке(ЗакладкаНачала);
		ПозицияОкончания = ПозицияНачала + СтрДлина("{ЗаполняемоеПоле}") + 1;
		
		ФорматированныйДокумент.Удалить(ЗакладкаНачала, ЗакладкаКонца);
		ФорматированныйДокумент.Вставить(ЗакладкаНачала, РедактируемыйПараметр);
		
		ЗакладкаКонца = ФорматированныйДокумент.ПолучитьЗакладкуПоПозиции(ПозицияОкончания);
		Элементы.ФорматированныйДокумент.УстановитьГраницыВыделения(ЗакладкаНачала, ЗакладкаКонца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПредопределенныйБланкПоУмолчанию(Команда)
	ВосстановитьПредопределенныйБланкПоУмолчаниюНаСервере();
	Оповестить("ВосстановлениеПредопределенногоШаблона", Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВставитьБикОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.БикОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКоррСчетОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КоррСчетОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьБикКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.БикКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКоррСчетКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КоррСчетКонтрагента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьФаксимиле(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.Факсимиле"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРазрывСтраницы(Команда)
	ВставитьПараметр("/*РазрывСтраницы*/");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьЛоготип(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.Логотип"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДатуДокумента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ДатаДокумента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьНомерДокумента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.НомерДокумента"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДополнительныйРеквизит(Команда)
	Строки = ЭтаФорма.ДополнительныеРеквизитыТЗ.НайтиСтроки(Новый Структура("ИмяКоманды", Команда.Имя));
	Если Строки.Количество() <> 0 Тогда
		ВставитьПараметрИнфобазы(Строки[0].Реквизит);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииФИОИменительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизацииИнициалы"), "именительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииФИОРодительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизацииИнициалы"), "родительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииФИОДательный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизацииИнициалы"), "дательный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииФИОВинительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизацииИнициалы"), "винительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииФИОТворительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизацииИнициалы"), "творительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьРуководителяОрганизацииФИОПредложный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.РуководительОрганизацииИнициалы"), "предложный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаФИОИменительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагентаИнициалы"), "именительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаФИОРодительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагентаИнициалы"), "родительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаФИОДательный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагентаИнициалы"), "дательный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаФИОВинительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагентаИнициалы"), "винительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаФИОТворительный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагентаИнициалы"), "творительный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьДолжностьКонтактногоЛицаКонтрагентаФИОПредложный(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.КонтактноеЛицоКонтрагентаИнициалы"), "предложный");
КонецПроцедуры

&НаКлиенте
Процедура ВставитьПаспортныеДанные(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ПаспортныеДанные"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьПаспортныеДанныеКонтактногоЛица(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ПаспортныеДанныеКонтактногоЛица"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОГРНОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ОГРНОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОКВЭДОрганизации(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ОКВЭДОрганизации"));
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОГРНКонтрагента(Команда)
	ВставитьПараметрИнфобазы(ПредопределенноеЗначение("Перечисление.ПараметрыБланковДоговоровСКонтрагентами.ОГРНКонтрагента"));
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

&НаКлиенте
Процедура ВставитьПараметр(Значение)
	
	ЗакладкаНачала = 0;
	ЗакладкаОкончания = 0;
	Элементы.ФорматированныйДокумент.ПолучитьГраницыВыделения(ЗакладкаНачала, ЗакладкаОкончания);
	Попытка
		ПозицияНачала = ФорматированныйДокумент.ПолучитьПозициюПоЗакладке(ЗакладкаНачала);
		ПозицияОкончания = ФорматированныйДокумент.ПолучитьПозициюПоЗакладке(ЗакладкаОкончания);
		
		Если ЗакладкаНачала <> ЗакладкаОкончания Тогда 
			ФорматированныйДокумент.Удалить(ЗакладкаНачала, ЗакладкаОкончания);
			Элементы.ФорматированныйДокумент.УстановитьГраницыВыделения(ЗакладкаНачала, ЗакладкаНачала);
		КонецЕсли;
		ФорматированныйДокумент.Вставить(ЗакладкаНачала, Значение);
		
		ПозицияОкончания = ПозицияНачала + СтрДлина(Значение);
		ЗакладкаОкончания = ФорматированныйДокумент.ПолучитьЗакладкуПоПозиции(ПозицияОкончания);
		Элементы.ФорматированныйДокумент.УстановитьГраницыВыделения(ЗакладкаНачала, ЗакладкаОкончания);
		
		ЭтаФорма.Модифицированность = Истина;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция РедактируемыйПараметр()
	
	Для НомерПараметра = 0 По Объект.РедактируемыеПараметры.Количество() Цикл
		Представление = "{ЗаполняемоеПоле" + (НомерПараметра + 1) + "}";
		Если ФорматированныйДокумент.НайтиТекст(Представление) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Идентификатор = "parameter" + (НомерПараметра + 1);
		Если Объект.РедактируемыеПараметры.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор)).Количество() <> 0 Тогда
			Прервать;
		Иначе
			НоваяСтрока = Объект.РедактируемыеПараметры.Добавить();
			НоваяСтрока.Представление = Представление;
			НоваяСтрока.Идентификатор = Идентификатор;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

&НаСервере
Функция ПараметрИнфобазы(Параметр, Падеж = Неопределено)
	
	Падежи = Новый Массив;
	Падежи.Добавить(Неопределено);
	Падежи.Добавить("именительный");
	Падежи.Добавить("родительный");
	Падежи.Добавить("дательный");
	Падежи.Добавить("винительный");
	Падежи.Добавить("творительный");
	Падежи.Добавить("предложный");
	
	НомерПараметра = 0;
	ПерейтиКСледующемуПараметру = Истина;
	
	Пока ПерейтиКСледующемуПараметру Цикл
		
		Если ТипЗнч(Параметр) = Тип("ПеречислениеСсылка.ПараметрыБланковДоговоровСКонтрагентами") Тогда
			Если НомерПараметра = 0 Тогда
				Представление = "{" + Параметр;
			Иначе
				Представление = "{" + Параметр + (НомерПараметра + 1);
			КонецЕсли;
		ИначеЕсли ТипЗнч(Параметр) = Тип("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения") Тогда
			Если НомерПараметра = 0 Тогда
				Представление = "{" + Параметр.Наименование;
			Иначе
				Представление = "{" + Параметр.Наименование + (НомерПараметра + 1);
			КонецЕсли;
		КонецЕсли;
		
		ПерейтиКСледующему = Ложь;
		Для каждого ПадежПараметраВТексте Из Падежи Цикл
			ИскомоеПредставление = Представление;
			Если ПадежПараметраВТексте <> Неопределено Тогда
				ИскомоеПредставление = ИскомоеПредставление + " (" + ПадежПараметраВТексте + ")}";
			Иначе
				ИскомоеПредставление = ИскомоеПредставление + "}"
			КонецЕсли;
			
			Если ФорматированныйДокумент.НайтиТекст(ИскомоеПредставление) <> Неопределено Тогда
				ПерейтиКСледующему = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ПерейтиКСледующему Тогда
			НомерПараметра = НомерПараметра + 1;
			Продолжить;
		КонецЕсли;
		
		Если Падеж <> Неопределено Тогда
			ПадежПредставление = " (" + Падеж + ")";
		Иначе
			ПадежПредставление = "";
		КонецЕсли;
		
		Если ТипЗнч(Параметр) = Тип("ПеречислениеСсылка.ПараметрыБланковДоговоровСКонтрагентами") Тогда
			Представление = Представление + ПадежПредставление + "}";
			Идентификатор = "infoParameter" + Параметр + (НомерПараметра + 1);
		ИначеЕсли ТипЗнч(Параметр) = Тип("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения") Тогда
			ПараметрНаименованиеПредставление = СтрЗаменить(Параметр.Наименование, " ", "");
			ПараметрНаименованиеПредставление = СтрЗаменить(ПараметрНаименованиеПредставление, "(", "");
			ПараметрНаименованиеПредставление = СтрЗаменить(ПараметрНаименованиеПредставление, ")", "");
			
			Представление = Представление + "}";
			Идентификатор = "additionalParameter" + ПараметрНаименованиеПредставление + (НомерПараметра + 1);
		КонецЕсли;
			
		Если Объект.ПараметрыИнфобазы.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор)).Количество() <> 0 Тогда
			Прервать;
		Иначе
			НоваяСтрока = Объект.ПараметрыИнфобазы.Добавить();
			НоваяСтрока.Представление = Представление;
			НоваяСтрока.Идентификатор = Идентификатор;
			НоваяСтрока.Параметр = Параметр;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

&НаКлиенте
Процедура ВставитьПараметрИнфобазы(ПараметрИнфобазы, Падеж = Неопределено)
	
	ВставитьПараметр("%Параметр%");
	
	Если ФорматированныйДокумент.НайтиТекст("%Параметр%") <> Неопределено Тогда 
		
		Параметр = ПараметрИнфобазы(ПараметрИнфобазы, Падеж);
		
		ЗакладкаНачала = ФорматированныйДокумент.НайтиТекст("%Параметр%").ЗакладкаНачала;
		ЗакладкаКонца = ФорматированныйДокумент.НайтиТекст("%Параметр%").ЗакладкаКонца;
		
		ПозицияНачала = ФорматированныйДокумент.ПолучитьПозициюПоЗакладке(ЗакладкаНачала);
		ПозицияОкончания = ПозицияНачала + СтрДлина(Параметр);
		
		ФорматированныйДокумент.Удалить(ЗакладкаНачала, ЗакладкаКонца);
		ФорматированныйДокумент.Вставить(ЗакладкаНачала, Параметр);
		
		ЗакладкаКонца = ФорматированныйДокумент.ПолучитьЗакладкуПоПозиции(ПозицияОкончания);
		Элементы.ФорматированныйДокумент.УстановитьГраницыВыделения(ЗакладкаНачала, ЗакладкаКонца);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьПредопределенныйБланкПоУмолчаниюНаСервере()
	МакетДоговора = Справочники.БланкиДоговоров.ПолучитьМакет(Объект.МакетПредопределенногоБланка);
	ТекстХТМЛ = МакетДоговора.ПолучитьТекст();
	Вложения = Новый Структура;
	
	РедактируемыеПараметры = Объект.РедактируемыеПараметры.Выгрузить();
	
	Если РедактируемыеПараметры.Количество() <> Объект.КоличествоРедактируемыхПараметров Тогда 
		
		ТЗ = Новый ТаблицаЗначений;
		ТЗ.Колонки.Добавить("Представление");
		ТЗ.Колонки.Добавить("Идентификатор");
		
		Для Каждого Строка Из РедактируемыеПараметры Цикл 
			Если Строка.НомерСтроки <= Объект.КоличествоРедактируемыхПараметров Тогда 
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока.Представление = Строка.Представление;
				НоваяСтрока.Идентификатор = Строка.Идентификатор;
			КонецЕсли;
		КонецЦикла;
		
		Объект.РедактируемыеПараметры.Загрузить(ТЗ);
	КонецЕсли;
	
	Объект.ПараметрыИнфобазы.Очистить();
	
	Падежи = Новый Массив;
	Падежи.Добавить(Неопределено);
	Падежи.Добавить("именительный");
	Падежи.Добавить("родительный");
	Падежи.Добавить("дательный");
	Падежи.Добавить("винительный");
	Падежи.Добавить("творительный");
	Падежи.Добавить("предложный");
	
	Для каждого ПараметрПеречисление Из Перечисления.ПараметрыБланковДоговоровСКонтрагентами Цикл
		
		Для каждого Падеж Из Падежи Цикл
			Если Падеж = Неопределено Тогда
				ПредставлениеПадежа = "";
			Иначе
				ПредставлениеПадежа = " (" + Падеж + ")";
			КонецЕсли;
			
			Параметр = "{" + Строка(ПараметрПеречисление) + ПредставлениеПадежа + "}";
			ЧислоВхождений = СтрЧислоВхождений(ТекстХТМЛ, Параметр);
			Для НомерПараметра = 1 По ЧислоВхождений Цикл
				Если НомерПараметра = 1 Тогда
					Представление = "{" + Строка(ПараметрПеречисление) + ПредставлениеПадежа + "%deleteSymbols%" + "}";
					Идентификатор = "infoParameter" + Строка(ПараметрПеречисление) + НомерПараметра;
				Иначе
					Представление = "{" + Строка(ПараметрПеречисление) + НомерПараметра + ПредставлениеПадежа + "}";
					Идентификатор = "infoParameter" + Строка(ПараметрПеречисление) + НомерПараметра;
				КонецЕсли;
				
				ПервоеВхождение = СтрНайти(ТекстХТМЛ, Параметр);
				
				ТекстХТМЛ = Лев(ТекстХТМЛ, ПервоеВхождение - 1) + Представление + Сред(ТекстХТМЛ, ПервоеВхождение + СтрДлина(Параметр));
				
				НоваяСтрока = Объект.ПараметрыИнфобазы.Добавить();
				НоваяСтрока.Представление = СтрЗаменить(Представление, "%deleteSymbols%", "");
				НоваяСтрока.Идентификатор = Идентификатор;
				НоваяСтрока.Параметр = ПараметрПеречисление;
				
			КонецЦикла;
			ТекстХТМЛ = СтрЗаменить(ТекстХТМЛ, "%deleteSymbols%", "");
		КонецЦикла;
	КонецЦикла;
	
	ФорматированныйДокумент.УстановитьHTML(ТекстХТМЛ, Вложения);
	
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура ДобавитьВставкуДополнительныхРеквизитов(ГруппаФормы, ДобавляемыеРеквизиты)
	
	Итератор = 0;
	Для Каждого Реквизит Из ДобавляемыеРеквизиты Цикл 
		
		ИмяКоманды = "ВставитьДополнительныйРеквизит" + ГруппаФормы.Имя + Итератор;
		НаименованиеРеквизита = Реквизит.Заголовок;
		
		Команда = ЭтаФорма.Команды.Добавить(ИмяКоманды);
		Команда.Заголовок = НаименованиеРеквизита;
		Команда.Действие = "ВставитьДополнительныйРеквизит";
		
		Кнопка = ЭтаФорма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), ГруппаФормы);
		Кнопка.ИмяКоманды = ИмяКоманды;
		Кнопка.Заголовок = НаименованиеРеквизита;
		
		НоваяСтрока = ЭтаФорма.ДополнительныеРеквизитыТЗ.Добавить();
		НоваяСтрока.ИмяКоманды = ИмяКоманды;
		НоваяСтрока.Реквизит = Реквизит;
		
		Итератор = Итератор + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
