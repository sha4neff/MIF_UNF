
#Область ОписаниеПеременных

&НаКлиенте
Перем МассивИзмененныхРеквизитов;

#КонецОбласти

#Область Служебные

&НаКлиенте
Процедура ИзменитьЗаголовокСвернутойГруппы()
	
	ШаблонЗаголовка = НСтр("ru ='Основание печати: %1'");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОснованиеПечати", "ЗаголовокСвернутогоОтображения", СтрШаблон(ШаблонЗаголовка, КонтекстПечати.ОснованиеПечати));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьИзменениеЗначенияРеквизита(ИмяРеквизита)
	
	Если МассивИзмененныхРеквизитов.Найти(ИмяРеквизита) = Неопределено Тогда
		
		МассивИзмененныхРеквизитов.Добавить(ИмяРеквизита);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияИЗакрытьФорму(Команда = Неопределено)
	
	ПараметрыЗакрытия = Новый Структура;
	Если Команда <> Неопределено Тогда
		
		ПараметрыЗакрытия.Вставить("Команда", Команда);
		
	КонецЕсли;
	
	ИзмененныеРеквизиты = Новый Структура;
	Для каждого ЭлементМассива Из МассивИзмененныхРеквизитов Цикл
		
		ИзмененныеРеквизиты.Вставить(ЭлементМассива, КонтекстПечати[ЭлементМассива]);
		
	КонецЦикла;
	ПараметрыЗакрытия.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаголовокФормы()
	
	ЭтаФорма.Заголовок = Обработки.РеквизитыПечати.ЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПодписиПоУмолчаниюНаСервере()
	
	//Если НЕ ЗначениеЗаполнено(КонтекстПечати.ДокументОснование) Тогда
	//	
	//	КонтекстПечати.ПодписьРуководителя = Неопределено;
	//	КонтекстПечати.ПодписьГлавногоБухгалтера = Неопределено;
	//	КонтекстПечати.ПодписьКладовщика = Неопределено;
	//	
	//ИначеЕсли ОбщегоНазначения.ЗначениеСсылочногоТипа(КонтекстПечати.ДокументОснование) Тогда
	//	
	//	МетаданныеДокумента = КонтекстПечати.ДокументОснование.Метаданные();
	//	
	//	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодписьРуководителя", МетаданныеДокумента) Тогда
	//		
	//		КонтекстПечати.ПодписьРуководителя = КонтекстПечати.ДокументОснование.ПодписьРуководителя;
	//		
	//	КонецЕсли;
	//	
	//	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодписьГлавногоБухгалтера", МетаданныеДокумента) Тогда
	//		
	//		КонтекстПечати.ПодписьГлавногоБухгалтера = КонтекстПечати.ДокументОснование.ПодписьГлавногоБухгалтера;
	//		
	//	КонецЕсли;
	//	
	//	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодписьКладовщика", МетаданныеДокумента) Тогда
	//		
	//		КонтекстПечати.ПодписьКладовщика = КонтекстПечати.ДокументОснование.ПодписьКладовщика;
	//		
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДоступностьКомандФормы()
	
	Если НЕ ПравоДоступа("Изменение", КонтекстПечати.Ссылка.Метаданные()) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаВосстановитьПодписиПоУмолчанию", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РедактироватьПредставлениеОснованияПечати", "Доступность", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МассивОбъектовМетаданных = Новый Массив(1);
	МассивОбъектовМетаданных[0] = Параметры.КонтекстПечати.Ссылка.Метаданные();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = МассивОбъектовМетаданных;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	ИменаРеквизитов = 
		"Организация,
		|ПодписьРуководителя, ПодписьГлавногоБухгалтера, ПодписьКладовщика,
		|Грузоотправитель, Грузополучатель,
		|ОснованиеПечати, ИдентификаторГосКонтракта";
	
	ЗаполнитьЗначенияСвойств(КонтекстПечати, Параметры.КонтекстПечати, ИменаРеквизитов);
	
	ЗаголовокФормы();
	ДоступностьКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МассивИзмененныхРеквизитов = Новый Массив;
	
КонецПроцедуры

#КонецОбласти

#Область Библиотеки

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму(Команда);
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, КонтекстПечати);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, КонтекстПечати, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	Возврат; // работа типового метода не предусмотрена
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, КонтекстПечати);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ОК(Команда)
	
	ЗаписатьИзмененияИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьПредставлениеОснованияПечати(Команда)
	
	ЗафиксироватьИзменениеЗначенияРеквизита("ОснованиеПечати");
	
	Если Элементы.ОснованиеПечати.Вид = ВидПоляФормы.ПолеВвода Тогда
		
		Элементы.ОснованиеПечати.Вид = ВидПоляФормы.ПолеНадписи;
		
	Иначе
		
		Элементы.ОснованиеПечати.Вид = ВидПоляФормы.ПолеВвода;
		Элементы.ОснованиеПечати.ПодсказкаВвода = НСтр("ru ='Представление основания печати'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПодписиПоУмолчанию(Команда)
	
	ПредыдущиеЗначения = Новый Структура("ПодписьРуководителя, ПодписьГлавногоБухгалтера, ПодписьКладовщика");
	ЗаполнитьЗначенияСвойств(ПредыдущиеЗначения, КонтекстПечати);
	
	ПолучитьПодписиПоУмолчаниюНаСервере();
	
	Для каждого ЭлементСтруктуры Из ПредыдущиеЗначения Цикл
		
		Если ЭлементСтруктуры.Значение <> КонтекстПечати[ЭлементСтруктуры.Ключ] Тогда
			
			ЗафиксироватьИзменениеЗначенияРеквизита(ЭлементСтруктуры.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Реквизиты

&НаКлиенте
Процедура ОснованиеПечатиПриИзменении(Элемент)
	
	ИзменитьЗаголовокСвернутойГруппы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьРуководителяПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьГлавногоБухгалтераПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьКладовщикаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтекстПечатиИдентификаторГосКонтрактаПриИзменении(Элемент)
	
	ЗафиксироватьИзменениеЗначенияРеквизита(Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти
