
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьРезультатВыполненияФоновогоЗадания(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗагрузки = Неопределено Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки = РезультатЗагрузки;
	
	Заголовок = НСтр("ru ='Загрузка цен контрагентов'");
	Если КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки.Статус = "Выполнено" Тогда 
		
		ТекстОповещения = НСтр("ru ='Цены контрагентов.
			|Загрузка данных завершена.'");
		
		ПоказатьОповещениеПользователя(ТекстОповещения, , Заголовок);
		
	ИначеЕсли КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки.Статус = "Ошибка" Тогда
		
		ПоказатьОповещениеПользователя(РезультатЗагрузки.КраткоеПредставлениеОшибки, , Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбработкиПодготовленныхДанных()
	
	Если КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки = Неопределено Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	Если КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки.Статус <> "Выполняется" Тогда 
		
		ОбработатьРезультатВыполненияФоновогоЗадания(КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки, Неопределено);
		Возврат;
		
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбработатьРезультатВыполненияФоновогоЗадания", ЭтотОбъект, Неопределено);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения		= НСтр("ru ='Загрузка цен контрагентов из внешнего источника.'");
	ПараметрыОжидания.ВыводитьОкноОжидания	= Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки, Обработчик, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНовыйИдентификатор()
	
	ЦенообразованиеФормулыСервер.СформироватьНовыйИдентификаторВидаЦен(Объект.ИдентификаторФормул, Объект.Наименование, Объект.Владелец.Наименование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере(Метаданные.РегистрыСведений.ЦеныНоменклатурыКонтрагентов, НастройкиЗагрузкиДанных, ЭтотОбъект, Ложь);
	// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаЦены) Тогда
		
		Объект.ВалютаЦены = Константы.НациональнаяВалюта.Получить();
		
	КонецЕсли;
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("ПараметрыДлительнойОперации", Новый Структура);
	КэшЗначений.ПараметрыДлительнойОперации.Вставить("РезультатЗагрузки",	Неопределено);
	КэшЗначений.ПараметрыДлительнойОперации.Вставить("ИдентификаторЗадания","");
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура обработчик события ПередЗаписью.
//
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СправочникВидЦенКонтрагентовЗапись");
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры //ПередЗаписью()

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область РеквизитыФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	СформироватьНовыйИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	СформироватьНовыйИдентификатор();
	
КонецПроцедуры

#КонецОбласти

#Область РеквизитыФормы

&НаКлиенте
Процедура СлужебныеРеквизиты(Команда)
	
	Элементы.ФормаСлужебныеРеквизиты.Пометка = НЕ Элементы.ФормаСлужебныеРеквизиты.Пометка;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияРазделитель1", "Видимость", Элементы.ФормаСлужебныеРеквизиты.Пометка);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИдентификаторФормул", "Видимость", Элементы.ФормаСлужебныеРеквизиты.Пометка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла
&НаКлиенте
Процедура ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника()
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстСообщения = НСтр("ru ='Необходимо записать вид цен контрагента'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
		
	КонецЕсли;
	
	НастройкиЗагрузкиДанных.Вставить("ВидЦенКонтрагента", Объект.Ссылка);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
	
	ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЦеныИзВнешнегоИсточника(Команда)
	
	ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗагрузки) = Тип("Структура") Тогда
		
		Если РезультатЗагрузки.ОписаниеДействия = "ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника" Тогда
		
			ЗагрузкаДанныхИзВнешнегоИсточника.ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных.ИмяФормыЗагрузкиДанныхИзВнешнихИсточников);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
			ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
			
		ИначеЕсли РезультатЗагрузки.ОписаниеДействия = "ОбработатьПодготовленныеДанные" Тогда
			
			ОбработатьПодготовленныеДанные(РезультатЗагрузки);
			ПослеОбработкиПодготовленныхДанных();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПодготовленныеДанные(РезультатЗагрузки)
	
	Если ЗначениеЗаполнено(КэшЗначений.ПараметрыДлительнойОперации.ИдентификаторЗадания) Тогда
		
		ДлительныеОперации.ОтменитьВыполнениеЗадания(КэшЗначений.ПараметрыДлительнойОперации.ИдентификаторЗадания);
		КэшЗначений.ПараметрыДлительнойОперации.ИдентификаторЗадания = Неопределено;
		
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("НастройкиЗагрузкиДанных", РезультатЗагрузки.НастройкиЗагрузкиДанных);
	ПараметрыПроцедуры.Вставить("ТаблицаСопоставленияДанных", ДанныеФормыВЗначение(РезультатЗагрузки.ТаблицаСопоставленияДанных, Тип("ТаблицаЗначений")));
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка цен контрагентов из внешнего источника.'");
	ПараметрыВыполнения.ЗапуститьВФоне				= Истина;
	
	ИмяМетода = "РегистрыСведений.ЦеныНоменклатурыКонтрагентов.ОбработатьПодготовленныеДанные";
	РезультатФоновогоЗадания = ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыПроцедуры, ПараметрыВыполнения);
	
	КэшЗначений.ПараметрыДлительнойОперации.РезультатЗагрузки		= РезультатФоновогоЗадания;
	КэшЗначений.ПараметрыДлительнойОперации.ИдентификаторЗадания	= РезультатФоновогоЗадания.ИдентификаторЗадания;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
